part of 'game_over_bloc.dart';

final class GameOverState extends Equatable {
  final LevelResult? result;

  const GameOverState({
    this.result,
  });

  GameOverState copyWith({
    LevelResult? Function()? result,
  }) => GameOverState(
    result: result != null ? result() : this.result,
  );

  @override
  List<Object?> get props => [result];
}
