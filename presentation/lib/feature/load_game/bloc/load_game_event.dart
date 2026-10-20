part of 'load_game_bloc.dart';

sealed class LoadGameEvent extends Equatable {
  const LoadGameEvent();

  @override
  List<Object?> get props => [];
}

final class LoadGameStarted extends LoadGameEvent {
  const LoadGameStarted();
}

final class LoadGameSaveTapped extends LoadGameEvent {
  final GameSave save;

  const LoadGameSaveTapped(this.save);

  @override
  List<Object?> get props => [save];
}
