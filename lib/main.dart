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
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");
  await PurchaseApi().init();
  await SharedPref().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  runApp(MyApp());
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
  MyApp({super.key});

  final GoRouter _goRouter = GoRouter(
    observers: [MyNavigatorObserver()],
    routes: [
      GoRoute(
        path: TabsPage.routeName,
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
          GoRoute(
            path: OnboardingPage.routeName,
            builder: (context, state) => const OnboardingPage(),
          )
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => ContentProvider()),
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          if (Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: SharedPref().isDarkTheme()
                    ? const Color(0xFF121212)
                    : const Color(0xFFFAFAFA),
                systemNavigationBarColor: SharedPref().isDarkTheme()
                    ? const Color(0xFF212121)
                    : const Color(0xFFFAFAFA),
              ),
            );
          }

          return CupertinoApp.router(
            title: 'Watchlistfy',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            theme: SharedPref().isDarkTheme()
                ? AppColors().darkTheme
                : AppColors().lightTheme,
            routerConfig: _goRouter,
            // initialRoute: '/',
            // routes: {
            //   "/onboarding": (context) => const OnboardingPage(),
            //   TabsPage.routeName: (context) => const TabsPage(),
            // },
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
