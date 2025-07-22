import 'package:coin_and_claw/core/constants.dart';
import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  final int coins; // Current coin count
  final double bonusProbability; // [0..1] chance per tap
  final Duration? autoTapInterval; // Null until ExtraLove bought
  final bool isFrenzyActive; // CatnipFrenzy flag
  final DateTime? frenzyEndsAt; // When frenzy expires
  final bool isHouseBought; // Victory flag
  final DateTime startTime; // Session start

  const GameState({
    required this.coins,
    required this.bonusProbability,
    this.autoTapInterval,
    this.isFrenzyActive = false,
    this.frenzyEndsAt,
    this.isHouseBought = false,
    required this.startTime,
  });

  factory GameState.initial() => GameState(
    coins: 0,
    bonusProbability: GameBalanceConstants.bonusProbabilityInitial,
    autoTapInterval: null,
    isFrenzyActive: false,
    frenzyEndsAt: null,
    isHouseBought: false,
    startTime: DateTime.now(),
  );

  GameState copyWith({
    int? coins,
    double? bonusProbability,
    Duration? autoTapInterval,
    bool? isFrenzyActive,
    DateTime? frenzyEndsAt,
    bool? isHouseBought,
    DateTime? startTime,
  }) {
    return GameState(
      coins: coins ?? this.coins,
      bonusProbability: bonusProbability ?? this.bonusProbability,
      autoTapInterval: autoTapInterval,
      isFrenzyActive: isFrenzyActive ?? this.isFrenzyActive,
      frenzyEndsAt: frenzyEndsAt,
      isHouseBought: isHouseBought ?? this.isHouseBought,
      startTime: startTime ?? this.startTime,
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
  ];
}
