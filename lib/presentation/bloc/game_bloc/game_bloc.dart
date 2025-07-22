import 'dart:async';
import 'dart:math';

import 'package:coin_and_claw/domain/models/game_state_model.dart';
import 'package:coin_and_claw/domain/models/update_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_and_claw/core/constants.dart';
import 'package:vibration/vibration.dart';

part 'game_event.dart';
part 'game_state.dart';

/// Bloc managing the core game loop
class GameBloc extends Bloc<GameEvent, GameState> {
  Timer? _autoTapTimer;
  Timer? _frenzyTimer;

  GameBloc() : super(const GameInitial()) {
    on<LoadGameEvent>(_onLoad);
    on<TapEvent>(_onTap);
    on<AutoTapEvent>(_onTap);
    on<PurchaseUpgradeEvent>(_onPurchaseUpgrade);
    on<FrenzyExpiredEvent>(_onFrenzyExpired);
  }

  /// Loads initial game data (e.g. defaults or persisted prefs).
  /// Emits [GameLoading] then [GameSuccess] or [GameError].
  Future<void> _onLoad(LoadGameEvent event, Emitter<GameState> emit) async {
    emit(const GameLoading());
    try {
      final initialModel = GameStateModel.initial();
      emit(GameSuccess(initialModel));
    } catch (_) {
      emit(const GameError('Failed to load game data'));
    }
  }

  /// Handles both manual tap ([TapEvent]) and auto‐tap ([AutoTapEvent]).
  /// Rolls RNG against [bonusProbability], awards coins, and emits new state.
  void _onTap(GameEvent event, Emitter<GameState> emit) async {
    if (state is! GameSuccess) return;
    final stateModel = (state as GameSuccess).gameStateModel;

    // Grant one coin per tap
    var newCoins = stateModel.coins + 1;

    // Maybe trigger a lucky bonus
    if (Random().nextDouble() < stateModel.bonusProbability) {
      newCoins += GameBalanceConstants.bonusRewardAmount;
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate();
      }
    }

    emit(GameSuccess(stateModel.copyWith(coins: newCoins)));
  }

  /// Processes a shop purchase request:
  /// - Checks if the player has enough coins.
  /// - Deducts the upgrade cost.
  /// - Applies the specific upgrade effect:
  ///   • luckyBonus   → doubles the bonusProbability
  ///   • extraLove    → starts an auto‐tap timer
  ///   • catnipFrenzy → activates a temporary frenzy window
  ///   • house        → marks victory
  Future<void> _onPurchaseUpgrade(
    PurchaseUpgradeEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameSuccess) return;
    final stateModel = (state as GameSuccess).gameStateModel;

    switch (event.type) {
      case UpgradeType.luckyBonus:
        if (stateModel.coins < GameBalanceConstants.costLuckyBonus) return;
        emit(
          GameSuccess(
            stateModel.copyWith(
              coins: stateModel.coins - GameBalanceConstants.costLuckyBonus,
              bonusProbability:
                  stateModel.bonusProbability *
                  GameBalanceConstants.bonusProbabilityMultiplier,
            ),
          ),
        );
        break;

      case UpgradeType.extraLove:
        if (stateModel.coins < GameBalanceConstants.costExtraLove) return;
        _autoTapTimer?.cancel();
        final interval = Duration(
          seconds: GameBalanceConstants.autoTapIntervalSeconds,
        );
        _autoTapTimer = Timer.periodic(interval, (_) => add(AutoTapEvent()));
        emit(
          GameSuccess(
            stateModel.copyWith(
              coins: stateModel.coins - GameBalanceConstants.costExtraLove,
              autoTapInterval: interval,
            ),
          ),
        );
        break;

      case UpgradeType.catnipFrenzy:
        if (stateModel.coins < GameBalanceConstants.costCatnipFrenzy) return;
        _frenzyTimer?.cancel();
        final endsAt = DateTime.now().add(
          Duration(seconds: GameBalanceConstants.frenzyDurationSeconds),
        );
        _frenzyTimer = Timer(
          Duration(seconds: GameBalanceConstants.frenzyDurationSeconds),
          () => add(FrenzyExpiredEvent()),
        );
        emit(
          GameSuccess(
            stateModel.copyWith(
              coins: stateModel.coins - GameBalanceConstants.costCatnipFrenzy,
              isFrenzyActive: true,
              frenzyEndsAt: endsAt,
            ),
          ),
        );
        break;

      case UpgradeType.house:
        if (stateModel.coins < GameBalanceConstants.costHouse) return;
        emit(
          GameSuccess(
            stateModel.copyWith(
              coins: stateModel.coins - GameBalanceConstants.costHouse,
              isHouseBought: true,
            ),
          ),
        );
        break;
    }
  }

  /// Called when the frenzy timer fires.
  /// Resets [isFrenzyActive] and clears [frenzyEndsAt].
  void _onFrenzyExpired(FrenzyExpiredEvent event, Emitter<GameState> emit) {
    if (state is! GameSuccess) return;
    final stateModel = (state as GameSuccess).gameStateModel;
    emit(
      GameSuccess(
        stateModel.copyWith(isFrenzyActive: false, frenzyEndsAt: null),
      ),
    );
  }

  /// Cleans up any active timers when the bloc is closed.
  @override
  Future<void> close() {
    _autoTapTimer?.cancel();
    _frenzyTimer?.cancel();
    return super.close();
  }
}
