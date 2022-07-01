import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

getNotifications(context){

  DeepmoodNotificationService.initialize(context);

  /// gives us the notification message, even when app has been terminated
  /// if user taps on it, it opens the app( or specific screen on app if mentioned )
  FirebaseMessaging.instance.getInitialMessage().then( (message) {
    if (message!=null) {
      print("Background terminated Notification received !");
    }
  });

  /// foreground notifications
  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification!=null) {
      print("Received foreground notification");
      DeepmoodNotificationService.initialize(context);
      DeepmoodNotificationService.display(message);
    }

  });

  /// app is opened but in background, and user taps on the notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {

    print("Background Notification received !");
  });
}

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Received notification : ${message.notification!.title}");
}