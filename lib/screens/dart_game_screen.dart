// === lib/screens/dart_game_screen.dart ===

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/dart_hit.dart';
import '../models/dart_player_record.dart';
import '../models/game_settings.dart';
import '../utils/hit_zone_classifier.dart';

class DartGameScreen extends StatefulWidget {
  const DartGameScreen({super.key});

  @override
  State<DartGameScreen> createState() => _DartGameScreenState();
}

class _DartGameScreenState extends State<DartGameScreen> {
  List<DartHit> dartHits = [];
  List<DartPlayerRecord> playerRecords = [];
  late GameSettings settings;
  late bool isPracticeMode;
  int currentPlayer = 1;
  int dartsThrown = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    settings = args['settings'] ?? GameSettings(playerCount: 1, separatedBull: false, outRule: 'Open');
    isPracticeMode = args['isPracticeMode'] ?? false;

    if (!isPracticeMode) {
      for (int i = 1; i <= settings.playerCount; i++) {
        playerRecords.add(DartPlayerRecord(playerId: i));
      }
    }
  }

  void _simulateThrow() {
    final random = Random();
    final randomX = (random.nextDouble() - 0.5) * 200;
    final randomY = (random.nextDouble() - 0.5) * 200;
    final position = Offset(randomX, randomY);

    final classified = HitZoneClassifier.classify(
      position,
      separatedBull: settings.separatedBull,
    );

    final newHit = DartHit(
      position: position,
      playerId: currentPlayer,
      zone: classified['zone'],
      score: classified['score'],
    );

    setState(() {
      dartHits.add(newHit);
      dartsThrown += 1;

      if (!isPracticeMode) {
        if (dartsThrown >= 3) {
          final playerHits = dartHits
              .where((hit) => hit.playerId == currentPlayer)
              .skip(playerRecords[currentPlayer - 1].rounds.length * 3)
              .take(3)
              .toList();
          playerRecords[currentPlayer - 1].addRound(playerHits);

          currentPlayer += 1;
          dartsThrown = 0;
          if (currentPlayer > settings.playerCount) {
            _showEndDialog();
          }
        }
      }
    });
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('比賽結束 🎯'),
        content: const Text('恭喜完成比賽！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/results',
                arguments: {
                  'playerRecords': playerRecords,
                  'isPracticeMode': false,
                },
              );
            },
            child: const Text('查看結果'),
          ),
        ],
      ),
    );
  }

  void _finishPractice() {
    final record = DartPlayerRecord(playerId: 1);
    record.addRound(dartHits);
    Navigator.pushNamed(
      context,
      '/results',
      arguments: {
        'playerRecords': [record],
        'isPracticeMode': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPracticeMode ? '練習模式' : '比賽模式'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isPracticeMode
                  ? '🎯 練習第 ${dartHits.length + 1} 鏢'
                  : '🎯 輪到 P$currentPlayer',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            if (!isPracticeMode)
              Text('第 ${dartsThrown + 1} 鏢 / 每人射3鏢', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _simulateThrow,
              child: const Text('🎯 射出一鏢'),
            ),
            const SizedBox(height: 30),
            if (isPracticeMode && dartHits.isNotEmpty)
              ElevatedButton.icon(
                onPressed: _finishPractice,
                icon: const Icon(Icons.done),
                label: const Text('✅ 完成練習'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
