import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/pages/home_page.dart';
import 'package:watchlistfy/pages/main/ai/ai_recommendation_page.dart';
import 'package:watchlistfy/pages/main/onboarding_page.dart';
import 'package:watchlistfy/pages/main/profile/consume_later_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_stats_page.dart';
import 'package:watchlistfy/pages/main/profile/user_list_page.dart';
import 'package:watchlistfy/pages/main/settings/settings_page.dart';
import 'package:watchlistfy/pages/social_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:watchlistfy/widgets/common/whats_new_dialog.dart';

class TabsPage extends StatefulWidget {
  static const routeName = "/";

  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  BaseState state = BaseState.init;
  final ValueNotifier<int> _selectedPageIndexNotifier = ValueNotifier(0);

  final QuickActions quickActions = const QuickActions();

  final List<Widget> _pages = [
    const HomePage(),
    // const SocialPage(),
    const AIRecommendationPage(),
    const SettingsPage(),
  ];

  void _selectPage(int index) {
    if (state != BaseState.disposed && state != BaseState.init) {
      _selectedPageIndexNotifier.value = index;
    }
  }

  bool androidInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (info.currentRoute(context)?.isFirst == true) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to close the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  initializeQuickActions() {
    quickActions.initialize((String shortcutType) async {
      await Future.delayed(const Duration(milliseconds: 1010));
      if (context.mounted) {
        if (shortcutType == 'action_user_list') {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (_) {
                return const UserListPage();
              },
            ),
          );
        } else if (shortcutType == 'action_consume_later') {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (_) {
                return const ConsumeLaterPage();
              },
            ),
          );
        } else if (shortcutType == 'action_profile') {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (_) {
                return const ProfilePage();
              },
            ),
          );
        } else if (shortcutType == 'action_stats') {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (_) {
                return const ProfileStatsPage();
              },
            ),
          );
        }
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_profile', localizedTitle: 'Profile'),
      const ShortcutItem(type: 'action_user_list', localizedTitle: 'User List'),
      const ShortcutItem(
          type: 'action_consume_later', localizedTitle: 'Watch Later'),
      const ShortcutItem(type: 'action_stats', localizedTitle: 'Statistics')
    ]);
  }

  @override
  void initState() {
    initializeQuickActions();
    super.initState();
    if (Platform.isAndroid) {
      BackButtonInterceptor.add(androidInterceptor);
    }
  }

  @override
  void dispose() {
    state = BaseState.disposed;
    if (Platform.isAndroid) {
      BackButtonInterceptor.remove(androidInterceptor);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //TODO FirebaseMessaging Init, create FCM
    if (state == BaseState.init) {
      Provider.of<GlobalProvider>(context, listen: false).initValues();

      await SharedPref().init().then(
        (_) async {
          final token = SharedPref().getTokenCredentials();
          final isIntroductionPresented =
              SharedPref().getIsIntroductionPresented();
          final canShowWhatsNewDialog =
              SharedPref().getShouldShowWhatsNewDialog();
          final didShowVersionPatch = SharedPref().getDidShowVersionPatch();
          final authProvider = Provider.of<AuthenticationProvider>(
            context,
            listen: false,
          );
          UserToken().setToken(token);

          bool isInternetAvailable =
              await InternetConnectionChecker().hasConnection;

          if (token == null) {
            authProvider.initAuthentication(false, null);
          } else if (isInternetAvailable) {
            await RefreshToken(token).refresh().then((value) async {
              if (value.token != null) {
                await PurchaseApi().userInit();
                if (PurchaseApi().userInfo != null &&
                    PurchaseApi().userInfo?.email.isNotEmpty == true) {
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
          } else {
            if (context.mounted) {
              showCupertinoDialog(
                context: context,
                builder: (_) => const ErrorDialog(
                  "No internet connection! You need internet access to use the app.",
                ),
              );
            }
          }

          setState(() {
            state = BaseState.view;
          });

          if (!isIntroductionPresented) {
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) {
                    return const OnboardingPage();
                  },
                ),
              );
            }
          }

          if (isIntroductionPresented &&
              canShowWhatsNewDialog &&
              !didShowVersionPatch) {
            await Future.delayed(
              const Duration(milliseconds: 300),
            );
            if (context.mounted) {
              try {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => const WhatsNewDialog(),
                );
              } catch (_) {}
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreviewProvider(),
      child: ValueListenableBuilder(
        valueListenable: _selectedPageIndexNotifier,
        builder: (context, selectedPageIndex, child) {
          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              onTap: _selectPage,
              currentIndex: selectedPageIndex,
              backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
              activeColor: CupertinoTheme.of(context).primaryColor,
              inactiveColor: CupertinoColors.systemGrey,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house, size: 24),
                  label: "Home",
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(CupertinoIcons.person_2_fill),
                //   label: "Socials",
                // ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.robot, size: 24),
                  label: "Recommendations",
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.gear, size: 24),
                  label: "Settings",
                ),
              ],
            ),
            tabBuilder: (context, index) {
              return CupertinoTabView(
                builder: (context) {
                  if (state == BaseState.loading || state == BaseState.init) {
                    return const LoadingView("Loading");
                  }
                  return SafeArea(child: _pages[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
