part of 'game_bloc.dart';

final class GameState extends Equatable {
  final GameLocation location;
  final bool isMapOpen;
  final bool isTraveling;
  final bool isBuildOpen;
  final Station? fireStation;
  final bool isWorkbenchOpen;
  final bool isFridgeOpen;
  final WaterKind? waterChoice;
  final bool isBookOpen;

  const GameState({
    required this.location,
    this.isMapOpen = false,
    this.isTraveling = false,
    this.isBuildOpen = false,
    this.fireStation,
    this.isWorkbenchOpen = false,
    this.isFridgeOpen = false,
    this.waterChoice,
    this.isBookOpen = false,
  });

  GameState copyWith({
    GameLocation? location,
    bool? isMapOpen,
    bool? isTraveling,
    bool? isBuildOpen,
    Station? Function()? fireStation,
    bool? isWorkbenchOpen,
    bool? isFridgeOpen,
    WaterKind? Function()? waterChoice,
    bool? isBookOpen,
  }) => GameState(
    location: location ?? this.location,
    isMapOpen: isMapOpen ?? this.isMapOpen,
    isTraveling: isTraveling ?? this.isTraveling,
    isBuildOpen: isBuildOpen ?? this.isBuildOpen,
    fireStation: fireStation != null ? fireStation() : this.fireStation,
    isWorkbenchOpen: isWorkbenchOpen ?? this.isWorkbenchOpen,
    isFridgeOpen: isFridgeOpen ?? this.isFridgeOpen,
    waterChoice: waterChoice != null ? waterChoice() : this.waterChoice,
    isBookOpen: isBookOpen ?? this.isBookOpen,
  );

  bool get isStationOpen => fireStation != null || isWorkbenchOpen || isFridgeOpen;

  @override
  List<Object?> get props => [
    location,
    isMapOpen,
    isTraveling,
    isBuildOpen,
    fireStation,
    isWorkbenchOpen,
    isFridgeOpen,
    waterChoice,
    isBookOpen,
  ];
}
