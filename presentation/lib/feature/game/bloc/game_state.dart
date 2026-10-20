part of 'game_bloc.dart';

final class GameState extends Equatable {
  final GameLocation location;
  final bool isMapOpen;
  final bool isBuildOpen;

  const GameState({
    required this.location,
    this.isMapOpen = false,
    this.isBuildOpen = false,
  });

  GameState copyWith({
    GameLocation? location,
    bool? isMapOpen,
    bool? isBuildOpen,
  }) => GameState(
    location: location ?? this.location,
    isMapOpen: isMapOpen ?? this.isMapOpen,
    isBuildOpen: isBuildOpen ?? this.isBuildOpen,
  );

  @override
  List<Object?> get props => [location, isMapOpen, isBuildOpen];
}
