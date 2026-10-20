import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/progress/model/game_level.dart';

final class GameSave {
  final GameLevel level;
  final GameLocation location;
  final DateTime savedAt;
  final PlayerStats stats;
  final List<MaterialStock> materials;
  final List<InventoryStack> inventory;
  final List<Pickup> pickups;
  final Pollution pollution;

  const GameSave({
    required this.level,
    required this.location,
    required this.savedAt,
    required this.stats,
    required this.materials,
    required this.inventory,
    required this.pickups,
    required this.pollution,
  });
}
