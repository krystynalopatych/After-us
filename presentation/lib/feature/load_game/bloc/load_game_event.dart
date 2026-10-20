part of 'load_game_bloc.dart';

sealed class LoadGameEvent {
  const LoadGameEvent();
}

final class LoadGameStarted extends LoadGameEvent {
  const LoadGameStarted();
}
