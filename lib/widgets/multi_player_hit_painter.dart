import 'dart:math';
import 'package:flutter/material.dart';
import '../models/dart_hit.dart';

// 多玩家飛鏢命中畫家
class MultiPlayerHitPainter extends CustomPainter {
  final List<DartHit> hits;

  MultiPlayerHitPainter(this.hits);

  // 根據玩家編號回傳顏色
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

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2); // 中心
    final radius = size.width / 2; // 半徑

    // 各重要區域半徑（比例固定）
    final rBull = radius * 0.04;
    final rInnerBull = radius * 0.08;
    final rTripleInner = radius * 0.50;
    final rTripleOuter = radius * 0.58;
    final rDoubleInner = radius * 0.80;
    final rDoubleOuter = radius * 0.88;
    final rOutside = radius;

    // =====================
    // 🎯 畫靶背景
    // =====================

    final outsidePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, rOutside, outsidePaint);

    final singleOuterPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, rDoubleInner, singleOuterPaint);

    final singleInnerPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, rTripleInner, singleInnerPaint);

    final doubleRingPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = rDoubleOuter - rDoubleInner;
    canvas.drawCircle(center, (rDoubleOuter + rDoubleInner) / 2, doubleRingPaint);

    final tripleRingPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = rTripleOuter - rTripleInner;
    canvas.drawCircle(center, (rTripleOuter + rTripleInner) / 2, tripleRingPaint);

    final innerBullPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, rInnerBull, innerBullPaint);

    final bullPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, rBull, bullPaint);

    // 畫分區切片
    final slicePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;
    for (int i = 0; i < 20; i++) {
      final angle = (2 * pi / 20) * i;
      final from = Offset(
        center.dx + rInnerBull * cos(angle),
        center.dy + rInnerBull * sin(angle),
      );
      final to = Offset(
        center.dx + rDoubleOuter * cos(angle),
        center.dy + rDoubleOuter * sin(angle),
      );
      canvas.drawLine(from, to, slicePaint);
    }

    // =====================
    // 🎯 畫每一個飛鏢命中點
    // =====================
    for (var hit in hits) {
      final paint = Paint()
        ..color = _colorForPlayer(hit.playerId)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center + hit.position, 5, paint);
    }

    // 畫中心小白點
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3, centerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
