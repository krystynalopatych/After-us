part of 'game_bloc.dart';

final class GameState {
  final GameLocation location;
  final bool isMapOpen;

  const GameState({
    required this.location,
    this.isMapOpen = false,
  });
}
