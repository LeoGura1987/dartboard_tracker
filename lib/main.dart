import 'package:flutter/material.dart';
// 匯入各個畫面
import 'screens/select_mode_screen.dart';     // 選擇模式（比賽 or 練習）
import 'screens/select_players_screen.dart';  // 選擇比賽玩家與規則
import 'screens/calibration_screen.dart';     // 設定飛鏢靶基準點
import 'screens/dart_game_screen.dart';        // 遊戲進行中（比賽或練習）
import 'screens/results_screen.dart';          // 顯示結果統計

void main() {
  runApp(const MyApp()); // 啟動 Flutter App
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Tracker', // App 標題
      theme: ThemeData.dark(), // 使用暗色主題
      debugShowCheckedModeBanner: false, // 不顯示 debug 標籤
      initialRoute: '/', // 預設首頁為 "/" (選擇模式畫面)
      routes: {
        // 路由設定：每個路由對應一個畫面
        '/': (context) => const SelectModeScreen(), // 首頁 - 選擇模式
        '/select_players': (context) => const SelectPlayersScreen(), // 選擇玩家與規則設定

        '/calibration': (context) => CalibrationScreen(
              // 設定靶心校正完成後，進入 /game
              onCalibrationComplete: (points) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                final settings = args['settings'] as GameSettings;
                final isPracticeMode = args['isPracticeMode'] as bool;

                Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: {
                    'settings': settings,
                    'calibrationPoints': points,
                    'isPracticeMode': isPracticeMode,
                  },
                );
              },
            ),

        '/game': (context) => const DartGameScreen(), // 比賽或練習中
        '/results': (context) => const ResultsScreen(), // 最後統計結果畫面
      },
    );
  }
}
