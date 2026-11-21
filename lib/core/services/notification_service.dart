//(VIV [Notification Service — 2026-11-02])

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//(VIV [Notification Service Class — 2026-11-02])
class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  //(VIV [Notification Channel — 2026-11-02])
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'vmimerinfov_monitoring',
    'VMimerInfoV Monitoring',
    description: 'VMimerInfoV mining monitoring notifications.',
    importance: Importance.high,
  );
  //) VIV [Notification Channel — 2026-11-02]

  //(VIV [Initialize Notifications — 2026-11-02])
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(settings: settings);

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);
  }
  //) VIV [Initialize Notifications — 2026-11-02]

  //(VIV [Request Notifications Permission — 2026-11-02])
  Future<bool?> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    return androidPlugin?.requestNotificationsPermission();
  }
  //) VIV [Request Notifications Permission — 2026-11-02]

  //(VIV [Show Notification — 2026-11-02])
  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'vmimerinfov_monitoring',
          'VMimerInfoV Monitoring',
          channelDescription: 'VMimerInfoV mining monitoring notifications.',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
  //) VIV [Show Notification — 2026-11-02]
}
//) VIV [Notification Service Class — 2026-11-02]

//) VIV [Notification Service — 2026-11-02]
