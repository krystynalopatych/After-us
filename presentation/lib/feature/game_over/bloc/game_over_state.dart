part of 'game_over_bloc.dart';

final class GameOverState extends Equatable {
  final LevelOutcome? outcome;

  const GameOverState({
    this.outcome,
  });

  GameOverState copyWith({
    LevelOutcome? Function()? outcome,
  }) => GameOverState(
    outcome: outcome != null ? outcome() : this.outcome,
  );

  @override
  List<Object?> get props => [outcome];
}
