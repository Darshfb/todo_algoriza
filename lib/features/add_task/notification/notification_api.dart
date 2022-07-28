import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifcations = FlutterLocalNotificationsPlugin();
   String sound = 'res_custom_notification.m4a';
  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('res_custom_notification.m4a')
      ),
      
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifcations.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );
}
