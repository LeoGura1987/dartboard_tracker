// main.dart
import 'package:flutter/material.dart';
import 'screens/select_mode_screen.dart';
import 'screens/select_players_screen.dart';
import 'screens/calibration_screen.dart';
import 'screens/dart_game_screen.dart';
import 'screens/results_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Tracker',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SelectModeScreen(),
        '/select_players': (context) => const SelectPlayersScreen(),
        '/calibration': (context) => const CalibrationScreen(),
        '/game': (context) => const DartGameScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}
