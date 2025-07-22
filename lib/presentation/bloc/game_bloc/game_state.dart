part of 'game_bloc.dart';

/// States emitted by GameBloc.
sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

/// Initial state before anything happens.
class GameInitial extends GameState {
  const GameInitial();
}

/// State during loading/persistence operations.
class GameLoading extends GameState {
  const GameLoading();
}

/// State representing a successful update with fresh model data.
class GameSuccess extends GameState {
  final GameStateModel gameStateModel;
  const GameSuccess(this.gameStateModel);

  @override
  List<Object?> get props => [gameStateModel];
}

/// State representing an error condition.
class GameError extends GameState {
  final String message;
  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}
