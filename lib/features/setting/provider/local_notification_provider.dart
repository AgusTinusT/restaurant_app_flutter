import 'package:flutter/foundation.dart';
import 'package:restaurant_app/features/setting/services/local_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService _notificationService;
  final SharedPreferences _prefs;

  static const String _dailyReminderKey = 'daily_reminder_active';
  static const int _dailyReminderId = 1;

  LocalNotificationProvider({
    required LocalNotificationService notificationService,
    required SharedPreferences prefs,
  }) : _notificationService = notificationService,
       _prefs = prefs;

  bool get isDailyReminderActive => _prefs.getBool(_dailyReminderKey) ?? false;

  Future<bool?> requestPermissions() {
    return _notificationService.requestPermissions();
  }

  Future<void> setDailyReminder(bool value) async {
    try {
      await _prefs.setBool(_dailyReminderKey, value);
      notifyListeners();

      if (value) {
        debugPrint('Scheduling daily reminder...');
        await _notificationService.scheduleDailyElevenAMNotification(
          id: _dailyReminderId,
        );
      } else {
        debugPrint('Cancelling daily reminder...');
        await _notificationService.cancelNotification(_dailyReminderId);
      }
    } catch (e) {
      debugPrint('Failed to set daily reminder: $e');

      await _prefs.setBool(_dailyReminderKey, !value);

      notifyListeners();

      rethrow;
    }
  }
}
