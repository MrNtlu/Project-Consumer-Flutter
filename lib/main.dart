import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/pages/main/onboarding_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_share_details_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/pages/tabs_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/common/notification_ui_view_model.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/interstitial_ad_handler.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/providers/theme_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
    _trackingTransparencyRequest();
  });

  // Parallel initialization for better performance
  await Future.wait([
    dotenv.load(fileName: ".env"),
    PurchaseApi().init(),
    SharedPref().init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  // Initialize ads after core services
  MobileAds.instance.initialize();

  if (kReleaseMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  InterstitialAdHandler().loadAds();

  runApp(const MyApp());
}

Future<void> _trackingTransparencyRequest() async {
  await Future.delayed(const Duration(milliseconds: 1000));

  if (Platform.isIOS || Platform.isMacOS) {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.authorized) {
      analytics.setAnalyticsCollectionEnabled(true);
      crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
    } else if (status == TrackingStatus.notDetermined) {
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();

      analytics.setAnalyticsCollectionEnabled(
        status == TrackingStatus.authorized,
      );
      crashlytics.setCrashlyticsCollectionEnabled(
        status == TrackingStatus.authorized && kReleaseMode,
      );
    }
  } else {
    analytics.setAnalyticsCollectionEnabled(true);
    crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Cache router instance to prevent recreation
  static final GoRouter _goRouter = GoRouter(
    observers: [MyNavigatorObserver()],
    initialLocation: TabsPage.routePath,
    routes: [
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: TabsPage.routePath,
        name: TabsPage.routeName,
        builder: (context, state) => const TabsPage(),
        routes: [
          GoRoute(
            path: 'movie/:id',
            builder: (context, state) => DetailsPage(
              id: state.pathParameters['id']!,
              contentType: ContentType.movie,
            ),
          ),
          GoRoute(
            path: 'tv/:id',
            builder: (context, state) => DetailsPage(
              id: state.pathParameters['id']!,
              contentType: ContentType.tv,
            ),
          ),
          GoRoute(
            path: 'anime/:id',
            builder: (context, state) => DetailsPage(
              id: state.pathParameters['id']!,
              contentType: ContentType.anime,
            ),
          ),
          GoRoute(
            path: 'game/:id',
            builder: (context, state) => DetailsPage(
              id: state.pathParameters['id']!,
              contentType: ContentType.game,
            ),
          ),
          GoRoute(
            path: 'profile/:username',
            builder: (context, state) =>
                ProfileDisplayPage(state.pathParameters['username']!),
          ),
          GoRoute(
            path: 'custom-list/:id',
            builder: (context, state) =>
                CustomListShareDetailsPage(state.pathParameters['id']!),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (state.fullPath == TabsPage.routePath &&
          !SharedPref().getIsIntroductionPresented()) {
        return OnboardingPage.routePath;
      }

      return null;
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => GlobalProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationUIViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          // Cache theme values to prevent repeated SharedPref calls
          final isDarkTheme = SharedPref().isDarkTheme();

          if (Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: isDarkTheme
                    ? const Color(0xFF121212)
                    : const Color(0xFFFAFAFA),
                systemNavigationBarColor: isDarkTheme
                    ? const Color(0xFF212121)
                    : const Color(0xFFFAFAFA),
              ),
            );
          }

          return CupertinoApp.router(
            title: 'Watchlistfy',
            debugShowCheckedModeBanner: false,
            // showPerformanceOverlay: kDebugMode,
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            theme: isDarkTheme ? AppColors().darkTheme : AppColors().lightTheme,
            routerConfig: _goRouter,
          );
        },
      ),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
    NavigationTracker().stackSize = routeStack.length;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
    NavigationTracker().stackSize = routeStack.length;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routeStack.removeLast();
    NavigationTracker().stackSize = routeStack.length;
  }
}
