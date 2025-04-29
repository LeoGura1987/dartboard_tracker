import 'package:flutter/material.dart';

// 資料模型：一個 DartHit 代表一支飛鏢的完整資訊
class DartHit {
  final Offset position; // 飛鏢命中的座標
  final int playerId;    // 玩家編號（1,2,3,4）
  final String zone;     // 命中區域標記（如 S20, T3, D-Bull）
  final int score;       // 此鏢得分（依照 zone 計算）

  DartHit({
    required this.position,
    required this.playerId,
    required this.zone,
    required this.score,
  });
}
