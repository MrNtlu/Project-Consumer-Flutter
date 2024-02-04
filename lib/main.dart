import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/pages/tabs_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/theme_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  runApp(const MyApp());
}

Future<void> _trackingTransparencyRequest() async {
  await Future.delayed(const Duration(milliseconds: 1000));

  final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.authorized) {
    analytics.setAnalyticsCollectionEnabled(true);
    crashlytics.setCrashlyticsCollectionEnabled(true);
  } else if(status == TrackingStatus.notDetermined) {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();

    analytics.setAnalyticsCollectionEnabled(status == TrackingStatus.authorized);
    crashlytics.setCrashlyticsCollectionEnabled(status == TrackingStatus.authorized);
  }
}

//TODO
// Deep linking https://codewithandrea.com/articles/flutter-deep-links/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

          return CupertinoApp(
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
            initialRoute: '/',
            routes: {
              TabsPage.routeName: (context) => const TabsPage(),
            },
          );
        },
      ),
    );
  }
}
