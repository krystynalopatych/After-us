import 'package:domain/inventory/model/water_bottle.dart';
import 'package:domain/inventory/model/water_kind.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/pollution/model/pollution_zone.dart';

enum InventoryItem {
  cattailRoot(
    hunger: 10,
    zone: .water,
  ),
  cattailRootCooked(
    hunger: 20,
    zone: .water,
  ),
  algae(
    hunger: 4,
    zone: .water,
  ),
  algaeSoaked(
    hunger: 10,
    zone: .water,
  ),
  berries(
    hunger: 10,
    thirst: 3,
    zone: .soil,
  ),
  cleanWater(thirst: 35),
  sodisLakeWater(
    thirst: 20,
    health: -15,
    zone: .water,
    water: .lake,
    bottle: .sodis,
  ),
  bottleLakeWater(
    thirst: 20,
    health: -15,
    zone: .water,
    water: .lake,
    bottle: .plastic,
  ),
  sodisStrainedWater(
    thirst: 25,
    health: -5,
    zone: .water,
    water: .strained,
    bottle: .sodis,
  ),
  bottleStrainedWater(
    thirst: 25,
    health: -5,
    zone: .water,
    water: .strained,
    bottle: .plastic,
  ),
  sodisFilteredWater(
    thirst: 35,
    water: .filtered,
    bottle: .sodis,
  ),
  bottleFilteredWater(
    thirst: 35,
    water: .filtered,
    bottle: .plastic,
  ),
  sodisBottle,
  prefilter,
  cookingPot,
  rocketStove,
  waterFilter;

  final double hunger;
  final double thirst;
  final double health;
  final PollutionZone? zone;
  final WaterKind? water;
  final WaterBottle? bottle;

  const InventoryItem({
    this.hunger = 0,
    this.thirst = 0,
    this.health = 0,
    this.zone,
    this.water,
    this.bottle,
  });

  bool get isConsumable => hunger > 0 || thirst > 0;

  bool get isDrink => thirst > hunger;

  InventoryItem? get emptyBottle => switch (bottle) {
    .sodis => sodisBottle,
    .plastic || null => null,
  };

  GameMaterial? get container => switch (bottle) {
    .plastic => GameMaterial.plastic,
    .sodis || null => null,
  };

  static InventoryItem filledWith(
    WaterKind water,
    WaterBottle bottle,
  ) => values.firstWhere((item) => item.water == water && item.bottle == bottle);
}
