import 'package:event/controllers/eventDetailsController.dart';
import 'package:event/services/notification_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

EventDetailController eventDetailController = Get.put(EventDetailController());

class HelperNotification {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('no_text');

    DarwinInitializationSettings initializationIos =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationIos);

    // Handling redirection and clicks
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
      try {
        if (details.payload != null && details.payload!.isNotEmpty) {
          eventDetailController.eventID = details.payload.toString();
          eventDetailController.getEvent("details");
        } else {}
      } catch (e) {}
      return;
    });
    // for IOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // Instantiating the notification API
    NotificationApi notificationApi = NotificationApi();

    // Listening to background messages for android and displaying it
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("..............onMessage.............");
      notificationApi.showNotification(message.notification!.title,
          message.notification!.body, message.data['event_id']);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }
}
