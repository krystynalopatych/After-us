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

final class GameLocationTapped extends GameEvent {
  const GameLocationTapped();
}

final class GameBuildClosed extends GameEvent {
  const GameBuildClosed();
}

final class GameStationTapped extends GameEvent {
  final Station station;

  const GameStationTapped(this.station);

  @override
  List<Object?> get props => [station];
}

final class GameFireClosed extends GameEvent {
  const GameFireClosed();
}

final class GameWorkbenchClosed extends GameEvent {
  const GameWorkbenchClosed();
}

final class GameBookTapped extends GameEvent {
  const GameBookTapped();
}

final class GameBookClosed extends GameEvent {
  const GameBookClosed();
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

final class GameWaterChoiceClosed extends GameEvent {
  const GameWaterChoiceClosed();
}
