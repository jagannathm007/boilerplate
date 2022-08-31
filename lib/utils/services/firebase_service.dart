import 'dart:convert';

import 'package:boilerplate/config/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterAppBadger.isAppBadgeSupported().then((value) {
    FlutterAppBadger.updateBadgeCount(1);
  });
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseService {
  setup() {
    initNotification();
  }

  Future<void> initNotification() async {
    //when app is [closed | killed | terminated]
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _notificationNavigateToItemDetail(message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      removeBadge();
      RemoteNotification? notification = message.notification;

      if (!kIsWeb && notification != null) {
        String? channelId;
        channelId = message.notification!.android?.channelId;

        String? currentRoute = Get.currentRoute;
        if (currentRoute.contains('messenger')) {
        } else {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId ?? channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'ic_notification',
                color: const Color(0xFF6EBAE7),
              ),
              iOS: const IOSNotificationDetails(),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      removeBadge();
      _notificationNavigateToItemDetail(message.data);
    });
    getToken();
  }

  void _notificationNavigateToItemDetail(dynamic data) async {
    if (data != null && data != '') {
      if (data["screen"] != null) {
        if (data['data'] != null) {
          dynamic newData;
          if (data['data'] is String) {
            newData = jsonDecode(data['data']);
          } else {
            newData = data['data'];
          }

          Get.toNamed('/${data['screen']}', arguments: newData);
        } else {
          Get.toNamed('/${data['screen']}');
        }
      }
    }
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print("::: token : $token");
    }
  }

  requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void addBadge(int count) {
    FlutterAppBadger.updateBadgeCount(count);
  }

  void removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  static Future<bool> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseConfig.platformOptions,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    return true;
  }
}
