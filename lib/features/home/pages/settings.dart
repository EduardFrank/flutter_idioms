import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:idioms/providers/theme_provider.dart';
import 'package:idioms/providers/tts_provider.dart';
import 'package:idioms/providers/notification_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Provider
                          .of<ThemeProvider>(context)
                          .isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    title: const Text('Dark Mode'),
                    trailing: Switch(
                      value: Provider
                          .of<ThemeProvider>(context)
                          .isDarkMode,
                      onChanged: (value) {
                        Provider
                            .of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Receive daily reminders to practice idioms'),
                    value: notificationProvider.notificationsEnabled,
                    onChanged: (value) {
                      notificationProvider.toggleNotifications(value);
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                  ListTile(
                    leading: const SizedBox(width: 25),
                    title: const Text('Notification Time'),
                    subtitle: Text(
                      'Daily reminder at ${notificationProvider.reminderTime}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => {
                      _selectNotificationTime(context, notificationProvider),
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectNotificationTime(
    BuildContext context,
    NotificationProvider notificationProvider,
  ) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime(0, 0, 0, notificationProvider.reminderTime.hour, notificationProvider.reminderTime.minute),
      ),
    );

    if (time != null) {
      notificationProvider.setReminderTime(
        NotificationTime(time.hour, time.minute),
      );
    }
  }
}