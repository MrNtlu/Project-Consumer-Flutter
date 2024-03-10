import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/onboarding_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_share_details_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/pages/tabs_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
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

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) { _trackingTransparencyRequest(); });
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

  runApp(MyApp());
}

Future<void> _trackingTransparencyRequest() async {
  await Future.delayed(const Duration(milliseconds: 1000));

  final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.authorized) {
    analytics.setAnalyticsCollectionEnabled(true);
    crashlytics.setCrashlyticsCollectionEnabled(true && kReleaseMode);
  } else if (status == TrackingStatus.notDetermined) {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();

    analytics.setAnalyticsCollectionEnabled(status == TrackingStatus.authorized);
    crashlytics.setCrashlyticsCollectionEnabled(status == TrackingStatus.authorized && kReleaseMode);
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
            builder: (context, state) => MovieDetailsPage(state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'tv/:id',
            builder: (context, state) => TVDetailsPage(state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'anime/:id',
            builder: (context, state) => AnimeDetailsPage(state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'game/:id',
            builder: (context, state) => GameDetailsPage(state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'profile/:username',
            builder: (context, state) => ProfileDisplayPage(state.pathParameters['username']!),
          ),
          GoRoute(
            path: 'custom-list/:id',
            builder: (context, state) => CustomListShareDetailsPage(state.pathParameters['id']!),
          ),
          GoRoute(
            path: OnboardingPage.routeName,
            builder: (context, state) => const OnboardingPage()
          )
        ],
      )
    ]
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => ContentProvider()),
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          Provider.of<ThemeProvider>(context);

          if (Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: SharedPref().isDarkTheme() ? const Color(0xFF121212) : const Color(0xFFFAFAFA),
              systemNavigationBarColor: SharedPref().isDarkTheme() ? const Color(0xFF212121) : const Color(0xFFFAFAFA),
            ));
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
