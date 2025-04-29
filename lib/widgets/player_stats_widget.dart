import 'dart:math';
import 'package:flutter/material.dart';
import '../models/dart_hit.dart';

// 玩家統計資訊元件
class PlayerStatsWidget extends StatelessWidget {
  final List<DartHit> hits;

  const PlayerStatsWidget({super.key, required this.hits});

  Color _colorForPlayer(int playerId) {
    switch (playerId) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // 直接用 mm 計算距離（畫布半徑=實體半徑）
  double _distanceFromCenterMm(Offset point) {
    return sqrt(point.dx * point.dx + point.dy * point.dy);
  }

  // 單一玩家統計數據
  Map<String, dynamic> _calculateStats(List<DartHit> playerHits) {
    if (playerHits.isEmpty) {
      return {
        'count': 0,
        'average': 0.0,
        'max': 0.0,
        'min': 0.0,
      };
    }

    List<double> distances =
        playerHits.map((hit) => _distanceFromCenterMm(hit.position)).toList();
    double average = distances.reduce((a, b) => a + b) / distances.length;
    double maxDist = distances.reduce(max);
    double minDist = distances.reduce(min);

    return {
      'count': playerHits.length,
      'average': average,
      'max': maxDist,
      'min': minDist,
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<int, List<DartHit>> playerGroups = {};
    for (var hit in hits) {
      playerGroups.putIfAbsent(hit.playerId, () => []);
      playerGroups[hit.playerId]!.add(hit);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: playerGroups.keys.map((playerId) {
        final stats = _calculateStats(playerGroups[playerId]!);
        return Card(
          color: _colorForPlayer(playerId).withOpacity(0.2),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _colorForPlayer(playerId),
              child: Text('P$playerId', style: const TextStyle(color: Colors.black)),
            ),
            title: Text(
              '出手數: ${stats['count']} | 平均距離: ${stats['average'].toStringAsFixed(2)} mm',
            ),
            subtitle: Text(
              '最大距離: ${stats['max'].toStringAsFixed(2)} mm | 最小距離: ${stats['min'].toStringAsFixed(2)} mm',
            ),
          ),
        );
      }).toList(),
    );
  }
}
