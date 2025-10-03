import 'package:flutter/material.dart';
import 'package:idioms/features/home/pages/home.dart';
import 'package:idioms/providers/notification_provider.dart';
import 'package:idioms/providers/theme_provider.dart';
import 'package:idioms/providers/tts_provider.dart';
import 'package:idioms/repos/repo.dart';
import 'package:idioms/theme.dart';
import 'package:provider/provider.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = Repo();
  await repo.init();

  initTimezone();

  runApp(const IdiomsApp());
}

class IdiomsApp extends StatelessWidget {
  const IdiomsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repo>(
          create: (_) => Repo(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TtsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
      ],
      child: Consumer2<Repo, ThemeProvider>(
        builder: (context, idiomRepo, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Idioms Learning App',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

Future<void> initTimezone() async {
  tz.initializeTimeZones();

  try {
    final tzName = await FlutterTimezone.getLocalTimezone();
    final tz.Location location = tz.getLocation(tzName.identifier);
    tz.setLocalLocation(location);
    print('Timezone set to $tzName');
  } catch (e) {
    // fallback to UTC so app still works
    tz.setLocalLocation(tz.getLocation('UTC'));
    print('Failed to set local timezone, falling back to UTC: $e');
  }
}
