part of 'game_bloc.dart';

final class GameState extends Equatable {
  final GameLocation location;
  final bool isMapOpen;

  const GameState({
    required this.location,
    this.isMapOpen = false,
  });

  GameState copyWith({
    GameLocation? location,
    bool? isMapOpen,
  }) => GameState(
    location: location ?? this.location,
    isMapOpen: isMapOpen ?? this.isMapOpen,
  );

  @override
  List<Object?> get props => [location, isMapOpen];
}
