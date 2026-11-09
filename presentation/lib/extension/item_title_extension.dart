import 'package:domain/construction/model/construction.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/pickup/model/pickup_kind.dart';

extension ConstructionTitleExtension on Construction {
  String get title => switch (this) {
    .waterFilter => 'Water filter',
    .compostPit => 'Compost pit',
    .rocketStove => 'Rocket stove',
    .gardenBed => 'Garden bed with greenhouse',
    .mushroomFarm => 'Mushroom farm',
    .clayFridge => 'Clay fridge',
  };
}

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
    .charcoal => 'Charcoal',
    .compost => 'Compost',
    .clayPot => 'Clay pot',
    .wetCardboard => 'Wet cardboard',
  };
}

extension InventoryItemTitleExtension on InventoryItem {
  String get title => switch (this) {
    .cattailRoot => 'Cattail roots',
    .cattailRootCooked => 'Cooked cattail roots',
    .algae => 'Algae',
    .algaeSoaked => 'Soaked algae',
    .berries => 'Berries',
    .mushrooms => 'Mushrooms',
    .mushroomsCooked => 'Cooked mushrooms',
    .potato => 'Potatoes',
    .potatoBoiled => 'Boiled potatoes',
    .cleanWater => 'Clean water',
    .sodisLakeWater => 'Lake water (SODIS)',
    .bottleLakeWater => 'Lake water',
    .sodisStrainedWater => 'Strained water (SODIS)',
    .bottleStrainedWater => 'Strained water',
    .sodisFilteredWater => 'Filtered water (SODIS)',
    .bottleFilteredWater => 'Filtered water',
    .sodisCleanWater => 'Clean water (SODIS)',
    .sodisBottle => 'SODIS bottle',
    .prefilter => 'Cloth prefilter',
    .cookingPot => 'Cooking pot',
    .rocketStove => 'Rocket stove',
    .waterFilter => 'Water filter',
    .clayFridge => 'Clay fridge',
    .gardenBed => 'Garden bed',
    .greenhouse => 'Greenhouse',
  };
}

extension PickupKindTitleExtension on PickupKind {
  String get title => material?.title ?? food?.title ?? '';
}

extension InventoryStackTitleExtension on InventoryStack {
  String get title => isSpoiled ? 'Spoiled ${item.title.toLowerCase()}' : item.title;
}
