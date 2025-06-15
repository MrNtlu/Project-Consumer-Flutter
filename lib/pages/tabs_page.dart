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

import 'package:watchlistfy/pages/main/profile/consume_later_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_stats_page.dart';
import 'package:watchlistfy/pages/main/profile/user_list_page.dart';
import 'package:watchlistfy/pages/main/settings/settings_page.dart';

import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:watchlistfy/widgets/common/whats_new_dialog.dart';

class TabsPage extends StatefulWidget {
  static const routeName = "tabs";
  static const routePath = "/";

  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  BaseState state = BaseState.init;
  final ValueNotifier<int> _selectedPageIndexNotifier = ValueNotifier(0);

  final QuickActions quickActions = const QuickActions();

  // Cache pages to prevent recreation on every build
  static const List<Widget> _pages = [
    HomePage(),
    AIRecommendationPage(),
    SettingsPage(),
  ];

  // Cache shared preferences values
  String? _cachedToken;
  bool? _cachedIsIntroductionPresented;
  bool? _cachedCanShowWhatsNewDialog;
  bool? _cachedDidShowVersionPatch;
  double? _cachedRefreshRate;

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

  void _initializeQuickActions() {
    quickActions.initialize((String shortcutType) async {
      await Future.delayed(const Duration(milliseconds: 1010));
      if (!mounted) return;

      Widget? targetPage;
      switch (shortcutType) {
        case 'action_user_list':
          targetPage = const UserListPage();
          break;
        case 'action_consume_later':
          targetPage = const ConsumeLaterPage();
          break;
        case 'action_profile':
          targetPage = const ProfilePage();
          break;
        case 'action_stats':
          targetPage = const ProfileStatsPage();
          break;
      }

      if (targetPage != null) {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (_) => targetPage!),
        );
      }
    });

    quickActions.setShortcutItems(const <ShortcutItem>[
      ShortcutItem(type: 'action_profile', localizedTitle: 'Profile'),
      ShortcutItem(type: 'action_user_list', localizedTitle: 'User List'),
      ShortcutItem(type: 'action_consume_later', localizedTitle: 'Watch Later'),
      ShortcutItem(type: 'action_stats', localizedTitle: 'Statistics')
    ]);
  }

  Future<void> _cacheSharedPreferences() async {
    final sharedPref = SharedPref();
    _cachedToken = sharedPref.getTokenCredentials();
    _cachedIsIntroductionPresented = sharedPref.getIsIntroductionPresented();
    _cachedCanShowWhatsNewDialog = sharedPref.getShouldShowWhatsNewDialog();
    _cachedDidShowVersionPatch = sharedPref.getDidShowVersionPatch();
    _cachedRefreshRate = sharedPref.getRefreshRate();
  }

  Future<void> _initializeApp({
    required WidgetsBinding widgetsBindingInstance,
  }) async {
    if (state != BaseState.init || !mounted) return;

    try {
      // Initialize global provider first
      if (mounted) {
        Provider.of<GlobalProvider>(context, listen: false).initValues();
      }

      // Initialize SharedPreferences and cache values
      await SharedPref().init();
      await _cacheSharedPreferences();

      if (_cachedRefreshRate == 0) {
        final display =
            widgetsBindingInstance.platformDispatcher.displays.first;
        RefreshRateHelper().setRefreshRate(display.refreshRate);
        SharedPref().setRefreshRate(display.refreshRate);
      } else {
        RefreshRateHelper().setRefreshRate(_cachedRefreshRate!);
      }

      if (!mounted) return;

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      UserToken().setToken(_cachedToken);

      // Check internet connection and handle authentication in parallel where possible
      final isInternetAvailable =
          await InternetConnectionChecker().hasConnection;

      if (_cachedToken == null) {
        authProvider.initAuthentication(false, null);
      } else if (isInternetAvailable) {
        await _handleTokenRefresh(authProvider);
      } else {
        if (mounted) {
          _showNoInternetDialog();
        }
        return;
      }

      if (!mounted) return;

      setState(() {
        state = BaseState.view;
      });

      // Show what's new dialog if needed
      _showWhatsNewDialogIfNeeded();
    } catch (error) {
      if (mounted) {
        setState(() {
          state = BaseState.view;
        });
      }
    }
  }

  Future<void> _handleTokenRefresh(AuthenticationProvider authProvider) async {
    try {
      final refreshResult = await RefreshToken(_cachedToken!).refresh();

      if (refreshResult.token != null) {
        await PurchaseApi().userInit();

        if (PurchaseApi().userInfo != null &&
            PurchaseApi().userInfo?.email.isNotEmpty == true) {
          authProvider.initAuthentication(true, PurchaseApi().userInfo);
        } else {
          _clearUserData();
          authProvider.initAuthentication(false, null);
        }
      } else {
        _clearUserData();
        authProvider.initAuthentication(false, null);
      }
    } catch (error) {
      _clearUserData();
      authProvider.initAuthentication(false, null);
    }
  }

  void _clearUserData() {
    PurchaseApi().userInfo = null;
    UserToken().setToken(null);
    SharedPref().deleteTokenCredentials();
  }

  void _showNoInternetDialog() {
    showCupertinoDialog(
      context: context,
      builder: (_) => const ErrorDialog(
        "No internet connection! You need internet access to use the app.",
      ),
    );
  }

  void _showWhatsNewDialogIfNeeded() {
    if (_cachedIsIntroductionPresented == true &&
        _cachedCanShowWhatsNewDialog == true &&
        _cachedDidShowVersionPatch == false) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          try {
            showCupertinoDialog(
              context: context,
              builder: (_) => const WhatsNewDialog(),
            );
          } catch (_) {}
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeQuickActions();

    if (Platform.isAndroid) {
      BackButtonInterceptor.add(androidInterceptor);
    }

    // Start initialization immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp(widgetsBindingInstance: WidgetsBinding.instance);
    });
  }

  @override
  void dispose() {
    state = BaseState.disposed;
    _selectedPageIndexNotifier.dispose();

    if (Platform.isAndroid) {
      BackButtonInterceptor.remove(androidInterceptor);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreviewProvider(),
      child: ValueListenableBuilder(
        valueListenable: _selectedPageIndexNotifier,
        builder: (context, selectedPageIndex, child) {
          final cupertinoTheme = CupertinoTheme.of(context);

          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              onTap: _selectPage,
              currentIndex: selectedPageIndex,
              backgroundColor: cupertinoTheme.barBackgroundColor,
              activeColor: cupertinoTheme.primaryColor,
              inactiveColor: CupertinoColors.systemGrey,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house, size: 24),
                  label: "Home",
                ),
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
