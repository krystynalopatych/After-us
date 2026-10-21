import 'package:domain/compost/model/compost_pit.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/player/model/meals_eaten.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/station/model/campfire_uses.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:equatable/equatable.dart';

final class GameSave extends Equatable {
  final GameLevel level;
  final GameLocation location;
  final DateTime savedAt;
  final GameDay day;
  final PlayerStats stats;
  final List<MaterialStock> materials;
  final List<InventoryStack> inventory;
  final List<Pickup> pickups;
  final Pollution pollution;
  final Set<Construction> constructions;
  final Set<Station> stations;
  final SunBottle? sunBottle;
  final CampfireUses campfireUses;
  final CompostPit compostPit;
  final MealsEaten meals;

  const GameSave({
    required this.level,
    required this.location,
    required this.savedAt,
    required this.day,
    required this.stats,
    required this.materials,
    required this.inventory,
    required this.pickups,
    required this.pollution,
    required this.constructions,
    required this.stations,
    this.sunBottle,
    this.campfireUses = const .none(),
    this.compostPit = const .empty(),
    this.meals = const .none(),
  });

  GameSave copyWith({
    GameLevel? level,
    GameLocation? location,
    DateTime? savedAt,
    GameDay? day,
    PlayerStats? stats,
    List<MaterialStock>? materials,
    List<InventoryStack>? inventory,
    List<Pickup>? pickups,
    Pollution? pollution,
    Set<Construction>? constructions,
    Set<Station>? stations,
    SunBottle? Function()? sunBottle,
    CampfireUses? campfireUses,
    CompostPit? compostPit,
    MealsEaten? meals,
  }) => GameSave(
    level: level ?? this.level,
    location: location ?? this.location,
    savedAt: savedAt ?? this.savedAt,
    day: day ?? this.day,
    stats: stats ?? this.stats,
    materials: materials ?? this.materials,
    inventory: inventory ?? this.inventory,
    pickups: pickups ?? this.pickups,
    pollution: pollution ?? this.pollution,
    constructions: constructions ?? this.constructions,
    stations: stations ?? this.stations,
    sunBottle: sunBottle != null ? sunBottle() : this.sunBottle,
    campfireUses: campfireUses ?? this.campfireUses,
    compostPit: compostPit ?? this.compostPit,
    meals: meals ?? this.meals,
  );

  @override
  List<Object?> get props => [
    level,
    location,
    savedAt,
    day,
    stats,
    materials,
    inventory,
    pickups,
    pollution,
    constructions,
    stations,
    sunBottle,
    campfireUses,
    compostPit,
    meals,
  ];
}
