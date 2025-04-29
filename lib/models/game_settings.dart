class GameSettings {
  final int playerCount; // 幾位玩家
  final bool separatedBull; // true: 25+50 分；false: fat bull 直接 50
  final String outRule; // 'Open', 'Double', 'Master'

  GameSettings({
    required this.playerCount,
    required this.separatedBull,
    required this.outRule,
  });
}
