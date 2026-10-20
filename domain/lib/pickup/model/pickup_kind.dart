import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';

enum PickupKind {
  plastic(material: .plastic),
  cloth(material: .cloth),
  sand(material: .sand),
  wood(material: .wood),
  metal(material: .metal),
  organics(material: .organics),
  cattail(food: .cattailRoot),
  algae(food: .algae),
  berryBush(food: .berries);

  final GameMaterial? material;
  final InventoryItem? food;

  const PickupKind({
    this.material,
    this.food,
  });
}
