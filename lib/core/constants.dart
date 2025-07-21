/// === Coins & bonus ===
class GameBalance {
  static const double bonusProbabilityInitial = 0.01; // 1%
  static const int bonusRewardAmount = 10;

  /// === LuckyBonus upgrade ===
  static const double bonusProbabilityMultiplier = 2;
  static const int costLuckyBonus = 100;

  /// === CatnipFrenzy (active) ===
  static const int costCatnipFrenzy = 250;
  static const int frenzyDurationSeconds = 8;

  /// === ExtraLove (passive) ===
  static const int costExtraLove = 300;
  static const int autoTapIntervalSeconds = 2;

  /// === Win condition ===
  static const int costHouse = 2000;
}

/// Helper class to manage sprite asset paths
class SpriteAssetsRoutes {
  /// === Cat sprites ===
  static const String catIdle = 'cat/cat-idle.png';
  static const String catExcited = 'cat/cat-excited.png';
  static const String catLaydown = 'cat/cat-laydown.png';
  static const String catSurprised = 'cat/cat-surprised.png';

  /// === Coin sprites ===
  static const String coin = 'coin/coin.png';

  /// Background sprite
  static const String roomBackground = 'background/room-background.png';
}
