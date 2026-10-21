part of 'game_bloc.dart';

final class GameState extends Equatable {
  final GameLocation location;
  final bool isMapOpen;
  final bool isBuildOpen;
  final bool isCampfireOpen;

  const GameState({
    required this.location,
    this.isMapOpen = false,
    this.isBuildOpen = false,
    this.isCampfireOpen = false,
  });

  GameState copyWith({
    GameLocation? location,
    bool? isMapOpen,
    bool? isBuildOpen,
    bool? isCampfireOpen,
  }) => GameState(
    location: location ?? this.location,
    isMapOpen: isMapOpen ?? this.isMapOpen,
    isBuildOpen: isBuildOpen ?? this.isBuildOpen,
    isCampfireOpen: isCampfireOpen ?? this.isCampfireOpen,
  );

  @override
  List<Object?> get props => [location, isMapOpen, isBuildOpen, isCampfireOpen];
}
