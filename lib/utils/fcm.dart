import 'dart:async';
import 'dart:convert';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _notifications = FlutterLocalNotificationsPlugin();

  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;

  init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
    );

    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(iOS: ios);

    _notifications.initialize(
      settings
    );
  }

  void setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    foregroundNotification();
    backgroundNotification();
    terminateNotification();

    _firebaseMessaging.getToken().then((value) async {
      if (PurchaseApi().userInfo != null && PurchaseApi().userInfo!.fcmToken != value) {
        await http.put(
          Uri.parse(APIRoutes().userRoutes.updateFCMToken),
          headers: UserToken().getBearerToken(),
          body: json.encode({
            "fcm_token": value,
          })
        );
      }
    });
  }

  void foregroundNotification() { // App foreground state
    FirebaseMessaging.onMessage.listen(
      (message) async {
        final notification = message.notification;
        final android = message.notification?.android;
        
        if (notification != null && android != null) {
          _notifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: DarwinNotificationDetails(
                badgeNumber: 1,
                subtitle: notification.body
              )
            )
          );
        }
      },
    );
  }

  void backgroundNotification() { // App background state
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {});
  }

  void terminateNotification() async { // App Closed state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {}
  }
}