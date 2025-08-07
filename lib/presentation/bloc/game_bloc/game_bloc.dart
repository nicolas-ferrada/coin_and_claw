import 'dart:async';
import 'dart:math';

import 'package:coin_and_claw/domain/models/game_state_model.dart';
import 'package:coin_and_claw/domain/models/update_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_and_claw/core/constants.dart';

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
    on<ClearEffectEvent>(_onClearEffect);
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
  void _onTap(GameEvent event, Emitter<GameState> emit) {
    // Early-out if the game isn’t in a playable state.
    if (state is! GameSuccess) return;
    final gameState = (state as GameSuccess).gameStateModel;

    // Determine how many coins this tap is worth
    final bool inFrenzy = gameState.isFrenzyActive;

    int multiplier =
        inFrenzy ? GameBalanceConstants.catnipFrenzyBaseMultiplier : 1;

    // Roll for a lucky bonus
    final bool bonusHit = Random().nextDouble() < gameState.bonusProbability;

    if (bonusHit) {
      final int bonus =
          GameBalanceConstants.bonusRewardAmount *
          (inFrenzy ? GameBalanceConstants.catnipBonusMultiplier : 1);
      multiplier += bonus;
    }

    // Work out which in-game effect (if any) should be emitted
    InGameEffect effect;

    if (event is AutoTapEvent) {
      effect = InGameEffect.autoTap;
    } else if (bonusHit) {
      effect = InGameEffect.bonusHit;
    } else {
      effect = InGameEffect.none;
    }

    emit(
      GameSuccess(
        gameState.copyWith(
          coins: gameState.coins + multiplier,
          inGameEffect: effect,
        ),
      ),
    );
  }

  /// Processes a shop purchase request:
  /// - Checks if the player has enough coins.
  /// - Deducts the upgrade cost.
  /// - Applies the specific upgrade effect:
  ///   • luckyBonus   → doubles the bonusProbability
  ///   • extraLove    → starts an auto‐tap timer
  ///   • catnipFrenzy → activates a temporary frenzy window that grants x2 base coins and x2 bonus coins
  ///   • house        → marks victory
  Future<void> _onPurchaseUpgrade(
    PurchaseUpgradeEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameSuccess) return;
    final stateModel = (state as GameSuccess).gameStateModel;

    // Effect to apply. None by default.
    var effect = InGameEffect.none;

    switch (event.type) {
      case UpgradeType.luckyBonus:
        if (stateModel.coins < GameBalanceConstants.costLuckyBonus) return;
        effect = InGameEffect.luckyBonusUpgradeBought;
        emit(
          GameSuccess(
            stateModel.copyWith(
              coins: stateModel.coins - GameBalanceConstants.costLuckyBonus,
              bonusProbability:
                  stateModel.bonusProbability *
                  GameBalanceConstants.bonusProbabilityMultiplier,
              inGameEffect: effect,
            ),
          ),
        );
        break;

      case UpgradeType.extraLove:
        if (stateModel.coins < GameBalanceConstants.costExtraLove) return;
        effect = InGameEffect.extraLoveUpgradeBought;
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
              inGameEffect: effect,
            ),
          ),
        );
        break;

      case UpgradeType.catnipFrenzy:
        if (stateModel.coins < GameBalanceConstants.costCatnipFrenzy) return;
        effect = InGameEffect.catnipFrenzyUpgradeBought;
        _frenzyTimer?.cancel();
        final endsAt = DateTime.now().add(
          Duration(seconds: GameBalanceConstants.catnipFrenzyDuration),
        );
        _frenzyTimer = Timer(
          Duration(seconds: GameBalanceConstants.catnipFrenzyDuration),
          () => add(FrenzyExpiredEvent()),
        );
        emit(
          GameSuccess(
            stateModel.copyWith(
              coins: stateModel.coins - GameBalanceConstants.costCatnipFrenzy,
              isFrenzyActive: true,
              frenzyEndsAt: endsAt,
              inGameEffect: effect,
            ),
          ),
        );
        break;

      case UpgradeType.house:
        if (stateModel.coins < GameBalanceConstants.costHouse) return;
        effect = InGameEffect.houseBought;
        emit(
          GameSuccess(
            stateModel.copyWith(
              coins: stateModel.coins - GameBalanceConstants.costHouse,
              isHouseBought: true,
              inGameEffect: effect,
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
    _frenzyTimer?.cancel();
    emit(
      GameSuccess(
        stateModel.copyWith(
          isFrenzyActive: false,
          frenzyEndsAt: null,
          inGameEffect: InGameEffect.catnipFrenzyExpired,
        ),
      ),
    );
  }

  /// Clears the current in-game effect, resetting the state.
  void _onClearEffect(ClearEffectEvent _, Emitter<GameState> emit) {
    if (state is GameSuccess) {
      final m = (state as GameSuccess).gameStateModel;
      emit(GameSuccess(m.copyWith(inGameEffect: InGameEffect.none)));
    }
  }

  /// Cleans up any active timers when the bloc is closed.
  @override
  Future<void> close() {
    _autoTapTimer?.cancel();
    _frenzyTimer?.cancel();
    return super.close();
  }
}
