part of 'game_bloc.dart';

final class GameState extends Equatable {
  final GameLocation location;
  final bool isMapOpen;
  final bool isBuildOpen;
  final bool isCampfireOpen;
  final bool isWorkbenchOpen;
  final WaterKind? waterChoice;

  const GameState({
    required this.location,
    this.isMapOpen = false,
    this.isBuildOpen = false,
    this.isCampfireOpen = false,
    this.isWorkbenchOpen = false,
    this.waterChoice,
  });

  GameState copyWith({
    GameLocation? location,
    bool? isMapOpen,
    bool? isBuildOpen,
    bool? isCampfireOpen,
    bool? isWorkbenchOpen,
    WaterKind? Function()? waterChoice,
  }) => GameState(
    location: location ?? this.location,
    isMapOpen: isMapOpen ?? this.isMapOpen,
    isBuildOpen: isBuildOpen ?? this.isBuildOpen,
    isCampfireOpen: isCampfireOpen ?? this.isCampfireOpen,
    isWorkbenchOpen: isWorkbenchOpen ?? this.isWorkbenchOpen,
    waterChoice: waterChoice != null ? waterChoice() : this.waterChoice,
  );

  bool get isStationOpen => isCampfireOpen || isWorkbenchOpen;

  @override
  List<Object?> get props => [location, isMapOpen, isBuildOpen, isCampfireOpen, isWorkbenchOpen, waterChoice];
}
