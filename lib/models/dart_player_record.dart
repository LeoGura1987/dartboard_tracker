// === lib/models/dart_player_record.dart ===

import 'dart_hit.dart';

class DartPlayerRecord {
  final int playerId;
  int totalScore = 0;
  List<List<DartHit>> rounds = [];

  DartPlayerRecord({required this.playerId});

  void addRound(List<DartHit> hits) {
    rounds.add(hits);
    totalScore += hits.fold<int>(0, (sum, hit) => sum + hit.score);
  }

  void undoLastRound() {
    if (rounds.isNotEmpty) {
      final lastHits = rounds.removeLast();
      totalScore -= lastHits.fold<int>(0, (sum, hit) => sum + hit.score);
    }
  }
}