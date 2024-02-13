import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/pages/home_page.dart';
import 'package:watchlistfy/pages/main/ai/ai_recommendation_page.dart';
import 'package:watchlistfy/pages/main/onboarding_page.dart';
import 'package:watchlistfy/pages/settings_page.dart';
import 'package:watchlistfy/pages/social_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class TabsPage extends StatefulWidget {
  static const routeName = "/";

  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  BaseState state = BaseState.init;
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SocialPage(),
    const AIRecommendationPage(),
    const SettingsPage(),
  ];

  void _selectPage(int index) {
    if (state != BaseState.disposed && state != BaseState.init) {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  void dispose() {
    state = BaseState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //TODO FirebaseMessaging Init, create FCM
    if (state == BaseState.init) {
      Provider.of<GlobalProvider>(context, listen: false).initValues();

      await SharedPref().init().then((_) async {
        final token = SharedPref().getTokenCredentials();
        final isIntroductionPresented = SharedPref().getIsIntroductionPresented();
        final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
        UserToken().setToken(token);

        if (token == null) {
          authProvider.initAuthentication(false, null);
        } else {
          await RefreshToken(token).refresh().then((value) async {
            if (value.token != null) {
              await PurchaseApi().userInit();
              if (PurchaseApi().userInfo != null && PurchaseApi().userInfo?.email.isNotEmpty == true) {
                authProvider.initAuthentication(true, PurchaseApi().userInfo);
                state = BaseState.view;
              } else {
                PurchaseApi().userInfo = null;
                UserToken().setToken(null);
                SharedPref().deleteTokenCredentials();
                authProvider.initAuthentication(false, null);
              }
            } else {
              //Failed to login
              PurchaseApi().userInfo = null;
              UserToken().setToken(null);
              SharedPref().deleteTokenCredentials();
              authProvider.initAuthentication(false, null);
            }
          });
        }

        setState(() {
          state = BaseState.view;
        });

        if (!isIntroductionPresented) {
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) {
                  return const OnboardingPage();
                })
              );
            }
          }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreviewProvider(),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
          activeColor: CupertinoTheme.of(context).primaryColor,
          inactiveColor: CupertinoColors.systemGrey,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2_fill),
              label: "Socials",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/images/ai.svg", colorFilter: ColorFilter.mode(_selectedPageIndex == 2 ? CupertinoTheme.of(context).primaryColor : CupertinoColors.systemGrey2, BlendMode.srcIn)),
              label: "Assistant",
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings_solid),
              label: "Settings",
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              if (state == BaseState.loading || state == BaseState.init) {
                return const LoadingView("Please wait");
              }
              return SafeArea(child: _pages[index]);
            },
          );
        },
      ),
    );
  }
}
