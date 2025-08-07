part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
  @override
  List<Object?> get props => [];
}

/// Load initial game state
class LoadGameEvent extends GameEvent {}

/// User tapped the cat
class TapEvent extends GameEvent {}

/// Fired by a periodic timer when ExtraLove is active
class AutoTapEvent extends GameEvent {}

/// User purchased an upgrade
class PurchaseUpgradeEvent extends GameEvent {
  final UpgradeType type;
  const PurchaseUpgradeEvent(this.type);
}

/// Frenzy has just been activated
class ActivateFrenzyEvent extends GameEvent {}

/// Frenzy timer expired
class FrenzyExpiredEvent extends GameEvent {}

/// Clear the current in-game effect (e.g. after animation)
class ClearEffectEvent extends GameEvent {}
