// === lib/models/dart_hit.dart ===

import 'package:flutter/material.dart';

class DartHit {
  final Offset position;
  final int playerId;
  final String zone;
  final int score;

  DartHit({
    required this.position,
    required this.playerId,
    required this.zone,
    required this.score,
  });
}
