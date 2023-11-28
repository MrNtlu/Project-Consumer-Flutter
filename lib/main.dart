import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/theme_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref().init();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  final status = await AppTrackingTransparency.requestTrackingAuthorization();
  final shouldActivateAnalytics = status == TrackingStatus.authorized || status == TrackingStatus.notSupported;
  analytics.setAnalyticsCollectionEnabled(shouldActivateAnalytics);
  crashlytics.setCrashlyticsCollectionEnabled(shouldActivateAnalytics);
}

//TODO: Cupertino Widgets
// https://docs.flutter.dev/ui/widgets/cupertino
// Widgets https://github.com/MrNtlu/Asset-Manager-Flutter/tree/master/lib/common/widgets

// Refresh Token
// https://www.google.com/search?q=flutter+jwt+refresh+token&oq=flutter+jwt+refresh+token

// Routing https://docs.flutter.dev/cookbook/navigation/named-routes

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        return CupertinoApp(
          title: 'Watchlistfy',
          theme: SharedPref().isDarkTheme() ? AppColors().darkTheme : AppColors().lightTheme,
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Title"),
      ),
      resizeToAvoidBottomInset: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
