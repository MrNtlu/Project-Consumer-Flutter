import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/pages/home_page.dart';
import 'package:watchlistfy/pages/settings_page.dart';
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
        final authProvider =
            Provider.of<AuthenticationProvider>(context, listen: false);
        UserToken().setToken(token);

        if (token == null) {
          authProvider.initAuthentication(false, null);
        } else {
          await RefreshToken(token).refresh().then((value) async {
            if (value.token != null) {
              await PurchaseApi().userInit();
              authProvider.initAuthentication(true, PurchaseApi().userInfo);
              state = BaseState.view;
            } else {
              //Failed to login
              UserToken().setToken(null);
              SharedPref().deleteTokenCredentials();
              authProvider.initAuthentication(false, null);
            }
          });
        }

        setState(() {
          state = BaseState.view;
        });
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill),
              label: "Home",
            ),
            BottomNavigationBarItem(
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
