part of 'load_game_bloc.dart';

final class LoadGameState extends Equatable {
  final List<GameSave> saves;

  const LoadGameState({
    this.saves = const [],
  });

  LoadGameState copyWith({
    List<GameSave>? saves,
  }) => LoadGameState(
    saves: saves ?? this.saves,
  );

  @override
  List<Object?> get props => [saves];
}
