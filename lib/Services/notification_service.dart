import 'package:deepmood/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DeepmoodNotificationService {

  static AndroidNotificationChannel deepmoodNotificationChannel = AndroidNotificationChannel(
    "deepmood_notification", //ID
    "App Notifications",//name
    "The DeepMood Notification channel",//description
    importance: Importance.high,
    playSound: true,
  );

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async{

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(deepmoodNotificationChannel);

    final InitializationSettings initializationSettings = InitializationSettings( android: AndroidInitializationSettings('@mipmap/ic_launcher') );

    _notificationsPlugin.initialize(initializationSettings);

  }

  static void display(RemoteMessage message) async {

    final id = DateTime.now().millisecondsSinceEpoch ~/1000; // unique id of a notification set as the time it was recieved

    final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "deepmood_notification",
          "App Notifications",
          "The DeepMood Notification channel",
          importance: Importance.max,
          priority: Priority.high,
        )
    );


    await _notificationsPlugin.show(
      id,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
    );
  }
}
