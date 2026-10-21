part of 'game_over_bloc.dart';

final class GameOverState extends Equatable {
  final LevelResult? result;
  final bool isCompleted;

  const GameOverState({
    this.result,
    this.isCompleted = false,
  });

  GameOverState copyWith({
    LevelResult? Function()? result,
    bool? isCompleted,
  }) => GameOverState(
    result: result != null ? result() : this.result,
    isCompleted: isCompleted ?? this.isCompleted,
  );

  @override
  List<Object?> get props => [result, isCompleted];
}
