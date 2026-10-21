part of 'game_bloc.dart';

final class GameState extends Equatable {
  final GameLocation location;
  final bool isMapOpen;
  final bool isBuildOpen;
  final Station? fireStation;
  final bool isWorkbenchOpen;
  final WaterKind? waterChoice;

  const GameState({
    required this.location,
    this.isMapOpen = false,
    this.isBuildOpen = false,
    this.fireStation,
    this.isWorkbenchOpen = false,
    this.waterChoice,
  });

  GameState copyWith({
    GameLocation? location,
    bool? isMapOpen,
    bool? isBuildOpen,
    Station? Function()? fireStation,
    bool? isWorkbenchOpen,
    WaterKind? Function()? waterChoice,
  }) => GameState(
    location: location ?? this.location,
    isMapOpen: isMapOpen ?? this.isMapOpen,
    isBuildOpen: isBuildOpen ?? this.isBuildOpen,
    fireStation: fireStation != null ? fireStation() : this.fireStation,
    isWorkbenchOpen: isWorkbenchOpen ?? this.isWorkbenchOpen,
    waterChoice: waterChoice != null ? waterChoice() : this.waterChoice,
  );

  bool get isStationOpen => fireStation != null || isWorkbenchOpen;

  @override
  List<Object?> get props => [location, isMapOpen, isBuildOpen, fireStation, isWorkbenchOpen, waterChoice];
}
