part of 'game_over_bloc.dart';

sealed class GameOverEvent extends Equatable {
  const GameOverEvent();

  @override
  List<Object?> get props => [];
}

final class GameOverStarted extends GameOverEvent {
  const GameOverStarted();
}

final class GameOverContinueTapped extends GameOverEvent {
  const GameOverContinueTapped();
}
