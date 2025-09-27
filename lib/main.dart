import 'package:flutter/material.dart';
import 'package:idioms/pages/home.dart';
import 'package:idioms/providers/theme_provider.dart';
import 'package:idioms/repositories/repository.dart';
import 'package:idioms/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = Repository();
  await repo.init();

  runApp(const IdiomsApp());
}

class IdiomsApp extends StatelessWidget {
  const IdiomsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>(
          create: (_) => Repository(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer2<Repository, ThemeProvider>(
        builder: (context, idiomRepo, themeProvider, child) {
          return MaterialApp(
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


