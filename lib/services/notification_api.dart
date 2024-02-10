import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(
    String? title,
    String? body,
    String? payload,
  ) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body.toString(),
      htmlFormatBigText: true,
      contentTitle: title.toString(),
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      styleInformation: bigTextStyleInformation,
      'eventify',
      'Eventify.pro',
      importance: Importance.max,
      priority: Priority.max,
      icon: "no_text",
      channelShowBadge: true,
      largeIcon: const DrawableResourceAndroidBitmap("no_text"),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await notificationPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
