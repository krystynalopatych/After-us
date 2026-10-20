import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/pickup/model/pickup_kind.dart';

extension GameMaterialTitleExtension on GameMaterial {
  String get title => switch (this) {
    .plastic => 'Plastic',
    .cloth => 'Cloth',
    .sand => 'Sand',
    .wood => 'Wood',
    .metal => 'Metal',
    .organics => 'Organics',
    .cardboard => 'Cardboard',
    .seeds => 'Seeds',
    .clay => 'Clay',
    .oil => 'Oil',
    .chlorine => 'Chlorine',
    .electronics => 'Electronics',
  };
}

extension InventoryItemTitleExtension on InventoryItem {
  String get title => switch (this) {
    .cattailRoot => 'Cattail roots',
    .algae => 'Algae',
    .berries => 'Berries',
  };
}

extension PickupKindTitleExtension on PickupKind {
  String get title => material?.title ?? food?.title ?? '';
}
