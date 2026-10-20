part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

final class GameStarted extends GameEvent {
  const GameStarted();
}

final class GameMapTapped extends GameEvent {
  const GameMapTapped();
}

final class GameMapClosed extends GameEvent {
  const GameMapClosed();
}

final class GameLocationSelected extends GameEvent {
  final GameLocation location;

  const GameLocationSelected(this.location);

  @override
  List<Object?> get props => [location];
}

final class GameLakeWaterTapped extends GameEvent {
  const GameLakeWaterTapped();
}
