part of 'game_bloc.dart';

sealed class GameEvent {
  const GameEvent();
}

final class GameStarted extends GameEvent {
  const GameStarted();
}

final class GameMapTapped extends GameEvent {
  const GameMapTapped();
}

final class GameLocationSelected extends GameEvent {
  final GameLocation location;

  const GameLocationSelected(this.location);
}
