import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider extends ChangeNotifier {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _notificationsEnabled = false;
  NotificationTime _reminderTime = const NotificationTime(12, 0); // Default to 8:00 PM
  
  bool get notificationsEnabled => _notificationsEnabled;
  NotificationTime get reminderTime => _reminderTime;

  NotificationProvider() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    
    // Load saved settings
    _loadSettings();
  }

  void _loadSettings() {
    // In a real app, you would load these from shared preferences or a database
    // For now, we'll just use default values
    _notificationsEnabled = true; // Default to enabled
    notifyListeners();
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    
    if (enabled) {
      await _requestExactAlarmsPermission(); // Request permission before scheduling
      await _scheduleDailyReminder();
    } else {
      await _notifications.cancelAll();
    }
    
    notifyListeners();
  }

  Future<void> setReminderTime(NotificationTime time) async {
    _reminderTime = time;
    
    if (_notificationsEnabled) {
      await _requestExactAlarmsPermission(); // Request permission before scheduling
      await _scheduleDailyReminder();
    }
    
    notifyListeners();
  }

  Future<void> _requestExactAlarmsPermission() async {
    // Only request exact alarms permission on Android
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.scheduleExactAlarm.status;
      
      if (status.isDenied || status.isPermanentlyDenied) {
        try {
          await Permission.scheduleExactAlarm.request();
        } catch (e) {
          print('Failed to request exact alarm permission: $e');
        }
      }
    }
  }

  Future<void> _scheduleDailyReminder() async {
    await _notifications.cancelAll(); // Cancel existing notifications

    if (!_notificationsEnabled) return;

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'idiom_reminder_channel',
        'Daily Idiom Reminder',
        channelDescription: 'Reminds you to practice idioms',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );


    // Use tz.local after you've set it above
    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _reminderTime.hour,
      _reminderTime.minute,
    );

    // If the scheduled time is in the past, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
        0,
        'Time to learn idioms!',
        'Don\'t forget to practice your idioms today.',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }

  Future<void> showTestNotification() async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Channel',
        channelDescription: 'Used for testing notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      1,
      'Test Notification',
      'This is a test notification',
      notificationDetails,
    );
  }
}

class NotificationTime {
  final int hour;
  final int minute;

  const NotificationTime(this.hour, this.minute);

  @override
  String toString() {
    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}