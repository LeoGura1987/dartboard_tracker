import 'package:flutter/material.dart';
import '../models/game_settings.dart';
import '../models/dart_hit.dart';
import '../models/dart_player_record.dart';
import '../utils/hit_zone_classifier.dart';

class DartGameScreen extends StatefulWidget {
  const DartGameScreen({super.key});

  @override
  State<DartGameScreen> createState() => _DartGameScreenState();
}

class _DartGameScreenState extends State<DartGameScreen> {
  late GameSettings settings;
  late List<DartPlayerRecord> playerRecords;
  late bool isPracticeMode;

  int currentPlayerIndex = 0;
  int dartsThisRound = 0;
  List<DartHit> currentRoundHits = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    settings = args['settings'] as GameSettings;
    isPracticeMode = args['isPracticeMode'] ?? false;
    final calibrationPoints = args['calibrationPoints'] as List<Offset>;

    playerRecords = List.generate(
      settings.playerCount,
      (i) => DartPlayerRecord(playerId: i + 1),
    );
  }

  void onDartDetected(Offset detectedPosition) {
    final classified = HitZoneClassifier.classify(
      detectedPosition,
      separatedBull: settings.separatedBull,
    );

    final hit = DartHit(
      position: detectedPosition,
      playerId: currentPlayerIndex + 1,
      zone: classified['zone'],
      score: classified['score'],
    );

    currentRoundHits.add(hit);
    dartsThisRound += 1;

    setState(() {});
  }

  void _simulateThrow() {
    final simulatedPosition = Offset(50, 50);
    onDartDetected(simulatedPosition);
  }

  void _nextRound() {
    playerRecords[currentPlayerIndex].addRound(currentRoundHits);
    currentRoundHits = [];
    dartsThisRound = 0;

    if (!isPracticeMode) {
      currentPlayerIndex += 1;
      if (currentPlayerIndex >= settings.playerCount) {
        currentPlayerIndex = 0;
      }
    }

    setState(() {});
  }

  void _completeRound() {
    if (isPracticeMode) return;

    final currentRecord = playerRecords[currentPlayerIndex];
    currentRecord.addRound(currentRoundHits);

    final totalScore = currentRecord.totalScore;

    if (totalScore <= 0) {
      final lastHit = currentRoundHits.last;
      bool win = false;

      if (settings.outRule == 'Open') {
        win = true;
      } else if (settings.outRule == 'Double') {
        if (lastHit.zone.startsWith('D') || lastHit.zone == 'D-Bull') {
          win = true;
        }
      } else if (settings.outRule == 'Master') {
        if (lastHit.zone.startsWith('D') || lastHit.zone.startsWith('T') || lastHit.zone == 'D-Bull') {
          win = true;
        }
      }

      if (win) {
        _showWinner(currentRecord.playerId);
        return;
      } else {
        currentRecord.undoLastRound();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ 最後一鏢不符合出局規則，繼續比賽！')),
        );
      }
    }

    currentRoundHits = [];
    dartsThisRound = 0;

    currentPlayerIndex += 1;
    if (currentPlayerIndex >= settings.playerCount) {
      currentPlayerIndex = 0;
    }

    setState(() {});
  }

  void _showWinner(int winnerId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 比賽結束！'),
        content: Text('玩家 P$winnerId 勝利 🎯'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/results',
                (route) => false,
                arguments: playerRecords,
              );
            },
            child: const Text('查看結果'),
          ),
        ],
      ),
    );
  }

  void _finishPractice() {
    Navigator.pushNamed(
      context,
      '/results',
      arguments: playerRecords,
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerNum = currentPlayerIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPracticeMode ? '練習模式 🎯' : '比賽進行中 🎯'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPracticeMode)
              Text('👤 現在是 玩家 P$playerNum', style: const TextStyle(fontSize: 22)),

            Text('第 ${dartsThisRound + 1} 鏢 / 本輪共3鏢', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _simulateThrow,
              child: const Text('🎯 模擬射出一鏢'),
            ),

            if (isPracticeMode && dartsThisRound == 3) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextRound,
                child: const Text('🔁 下一輪'),
              ),
              ElevatedButton(
                onPressed: _finishPractice,
                child: const Text('✅ 完成練習'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
