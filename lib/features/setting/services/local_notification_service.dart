import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  static const String _androidChannelId = "3";
  static const String _androidChannelName = "Scheduled Notification";
  static const String _notificationTitle = 'Rekomendasi Restoran untukmu';
  static const String _notificationBody =
      'Yuk, cek restoran pilihan yang mungkin kamu suka hari ini!';
  static const int _notificationHour = 11;

  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await _plugin.initialize(initializationSettings);
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _requestIOSPermissions() ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return await _requestAndroidPermissions();
    }

    return false;
  }

  Future<bool?> _requestIOSPermissions() async {
    return _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<bool> _requestAndroidPermissions() async {
    final androidImplementation =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidImplementation == null) return false;

    final bool hasNotificationPermission =
        await androidImplementation.areNotificationsEnabled() ?? false;
    if (!hasNotificationPermission) {
      final bool? permissionGranted =
          await androidImplementation.requestNotificationsPermission();
      if (permissionGranted != true) return false;
    }

    final bool? hasExactAlarmPermission =
        await androidImplementation.requestExactAlarmsPermission();
    return hasExactAlarmPermission ?? false;
  }

  Future<void> scheduleDailyElevenAMNotification({required int id}) async {
    final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _plugin.zonedSchedule(
      id,
      _notificationTitle,
      _notificationBody,
      _nextInstanceOfElevenAM(),
      notificationDetails,
      payload: '/',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfElevenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _notificationHour,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
