import 'package:coin_and_claw/core/constants.dart';
import 'package:equatable/equatable.dart';

enum InGameEffect {
  none,
  bonusHit,
  autoTap,
  catnipFrenzyUpgradeBought,
  catnipFrenzyExpired,
  luckyBonusUpgradeBought,
  extraLoveUpgradeBought,
  houseBought,
}

class GameStateModel extends Equatable {
  final int coins; // Current coin count
  final double bonusProbability; // [0..1] chance per tap
  final Duration? autoTapInterval; // Null until ExtraLove bought
  final bool isFrenzyActive; // CatnipFrenzy flag
  final DateTime? frenzyEndsAt; // When frenzy expires
  final bool isHouseBought; // Victory flag
  final DateTime startTime; // Session start
  final InGameEffect inGameEffect; // Current effect state

  const GameStateModel({
    required this.coins,
    required this.bonusProbability,
    this.autoTapInterval,
    this.isFrenzyActive = false,
    this.frenzyEndsAt,
    this.isHouseBought = false,
    required this.startTime,
    this.inGameEffect = InGameEffect.none,
  });

  factory GameStateModel.initial() => GameStateModel(
    coins: 0,
    bonusProbability: GameBalanceConstants.bonusProbabilityInitial,
    autoTapInterval: null,
    isFrenzyActive: false,
    frenzyEndsAt: null,
    isHouseBought: false,
    startTime: DateTime.now(),
    inGameEffect: InGameEffect.none,
  );

  GameStateModel copyWith({
    int? coins,
    double? bonusProbability,
    Duration? autoTapInterval,
    bool? isFrenzyActive,
    DateTime? frenzyEndsAt,
    bool? isHouseBought,
    DateTime? startTime,
    InGameEffect? inGameEffect,
  }) {
    return GameStateModel(
      coins: coins ?? this.coins,
      bonusProbability: bonusProbability ?? this.bonusProbability,
      autoTapInterval: autoTapInterval ?? this.autoTapInterval,
      isFrenzyActive: isFrenzyActive ?? this.isFrenzyActive,
      frenzyEndsAt: frenzyEndsAt ?? this.frenzyEndsAt,
      isHouseBought: isHouseBought ?? this.isHouseBought,
      startTime: startTime ?? this.startTime,
      inGameEffect: inGameEffect ?? this.inGameEffect,
    );
  }

  @override
  List<Object?> get props => [
    coins,
    bonusProbability,
    autoTapInterval,
    isFrenzyActive,
    frenzyEndsAt,
    isHouseBought,
    startTime,
    inGameEffect,
  ];
}
