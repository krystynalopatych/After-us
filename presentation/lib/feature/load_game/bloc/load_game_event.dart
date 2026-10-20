part of 'load_game_bloc.dart';

sealed class LoadGameEvent {
  const LoadGameEvent();
}

final class LoadGameStarted extends LoadGameEvent {
  const LoadGameStarted();
}

final class LoadGameSaveTapped extends LoadGameEvent {
  final GameSave save;

  const LoadGameSaveTapped(this.save);
}
