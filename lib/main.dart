import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pomodoro_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/statistics_provider.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/timer_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/statistics_screen.dart';
import 'ui/theme/app_theme.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PomodoroProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: MaterialApp(
        title: 'Pomodoro Timer',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/timer': (context) => const TimerScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/statistics': (context) => const StatisticsScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}