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
  lakeWater(
    thirst: 20,
    health: -15,
    zone: .water,
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

  const InventoryItem({
    this.hunger = 0,
    this.thirst = 0,
    this.health = 0,
    this.zone,
  });

  bool get isConsumable => hunger > 0 || thirst > 0;

  bool get isDrink => thirst > hunger;
}
