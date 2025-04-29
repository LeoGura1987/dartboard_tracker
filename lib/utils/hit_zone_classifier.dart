import 'dart:math';
import 'package:flutter/material.dart';

// 命中區域分類工具
class HitZoneClassifier {
  static const double boardRadiusMm = 195.0; // 靶半徑 = 195 mm
  static const bool isSeparatedBull = true;  // ⬅️ S-Bull是否分開記25分? (true=Separated Bull, false=Fat Bull 50分)

  // 每個分數區對應的角度中心（順時針，從12點鐘方向開始）
  static const List<int> scoreOrder = [
    20, 1, 18, 4, 13, 6, 10, 15, 2, 17,
    3, 19, 7, 16, 8, 11, 14, 9, 12, 5
  ];

  // 判斷命中區域 (傳入 Offset，回傳 {zone, score})
  static Map<String, dynamic> classify(Offset point) {
    double dx = point.dx;
    double dy = point.dy;

    double distance = sqrt(dx * dx + dy * dy); // 與中心距離（px）
    double angle = atan2(dy, dx); // 弧度
    angle = angle * (180 / pi);   // 轉成角度
    if (angle < 0) angle += 360;  // 確保角度在0~360

    // --- 1. Outside
    if (distance > boardRadiusMm) {
      return {'zone': 'Miss', 'score': 0};
    }

    // --- 2. Bullseye
    if (distance <= boardRadiusMm * 0.04) {
      return {'zone': 'D-Bull', 'score': 50};
    }

    // --- 3. Inner Bull
    if (distance <= boardRadiusMm * 0.08) {
      if (isSeparatedBull) {
        return {'zone': 'S-Bull', 'score': 25};
      } else {
        return {'zone': 'S-Bull', 'score': 50};
      }
    }

    // --- 4. 找對應的分數區（披薩切片）
    int sliceIndex = ((angle + 9) % 360 ~/ 18); // 每片18度
    int baseScore = scoreOrder[sliceIndex];

    // --- 5. 判定哪一圈
    if (distance >= boardRadiusMm * 0.80 && distance <= boardRadiusMm * 0.88) {
      return {'zone': 'D$baseScore', 'score': baseScore * 2}; // Double Ring
    }
    if (distance >= boardRadiusMm * 0.50 && distance <= boardRadiusMm * 0.58) {
      return {'zone': 'T$baseScore', 'score': baseScore * 3}; // Triple Ring
    }
    return {'zone': 'S$baseScore', 'score': baseScore}; // Single 區
  }
}
