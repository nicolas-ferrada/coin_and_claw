import 'package:coin_and_claw/core/constants.dart';
import 'package:equatable/equatable.dart';

class GameStateModel extends Equatable {
  final int coins; // Current coin count
  final double bonusProbability; // [0..1] chance per tap
  final Duration? autoTapInterval; // Null until ExtraLove bought
  final bool isFrenzyActive; // CatnipFrenzy flag
  final DateTime? frenzyEndsAt; // When frenzy expires
  final bool isHouseBought; // Victory flag
  final DateTime startTime; // Session start

  const GameStateModel({
    required this.coins,
    required this.bonusProbability,
    this.autoTapInterval,
    this.isFrenzyActive = false,
    this.frenzyEndsAt,
    this.isHouseBought = false,
    required this.startTime,
  });

  factory GameStateModel.initial() => GameStateModel(
    coins: 0,
    bonusProbability: GameBalanceConstants.bonusProbabilityInitial,
    autoTapInterval: null,
    isFrenzyActive: false,
    frenzyEndsAt: null,
    isHouseBought: false,
    startTime: DateTime.now(),
  );

  GameStateModel copyWith({
    int? coins,
    double? bonusProbability,
    Duration? autoTapInterval,
    bool? isFrenzyActive,
    DateTime? frenzyEndsAt,
    bool? isHouseBought,
    DateTime? startTime,
  }) {
    return GameStateModel(
      coins: coins ?? this.coins,
      bonusProbability: bonusProbability ?? this.bonusProbability,
      autoTapInterval: autoTapInterval ?? this.autoTapInterval,
      isFrenzyActive: isFrenzyActive ?? this.isFrenzyActive,
      frenzyEndsAt: frenzyEndsAt ?? this.frenzyEndsAt,
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
