import 'package:domain/construction/model/construction.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:equatable/equatable.dart';

final class GameSave extends Equatable {
  final GameLevel level;
  final GameLocation location;
  final DateTime savedAt;
  final int day;
  final PlayerStats stats;
  final List<MaterialStock> materials;
  final List<InventoryStack> inventory;
  final List<Pickup> pickups;
  final Pollution pollution;
  final Set<Construction> constructions;

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
  });

  GameSave copyWith({
    GameLevel? level,
    GameLocation? location,
    DateTime? savedAt,
    int? day,
    PlayerStats? stats,
    List<MaterialStock>? materials,
    List<InventoryStack>? inventory,
    List<Pickup>? pickups,
    Pollution? pollution,
    Set<Construction>? constructions,
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
  ];
}
