import 'dart:math';
import 'package:flutter/material.dart';
import '../models/dart_player_record.dart';
import '../models/dart_hit.dart';
import '../widgets/multi_player_hit_painter.dart';
import '../widgets/player_stats_widget.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<DartPlayerRecord> playerRecords = args['playerRecords'] as List<DartPlayerRecord>;
    final bool isPracticeMode = args['isPracticeMode'] ?? false;

    // 整理所有命中點
    List<DartHit> allHits = [];
    for (var record in playerRecords) {
      for (var round in record.rounds) {
        for (var hit in round) {
          allHits.add(hit);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPracticeMode ? '練習結果 🧪' : '比賽結果 🏆'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '📋 玩家得分',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: playerRecords.length,
                itemBuilder: (context, index) {
                  final record = playerRecords[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('P${record.playerId}'),
                      ),
                      title: Text('總分：${record.totalScore} 分'),
                      subtitle: Text('輪數：${record.rounds.length} 輪'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            if (allHits.isNotEmpty) ...[
              const Text(
                '🎯 命中熱區分布',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: CustomPaint(
                  painter: MultiPlayerHitPainter(allHits),
                  child: Container(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '📊 命中距離統計',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              PlayerStatsWidget(hits: allHits),
            ],

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('🔄 重新開始'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
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