import 'package:domain/book/model/book_record.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';

enum WorkbenchRecipe {
  sodisBottle(
    ingredients: {GameMaterial.plastic: 1},
    result: .sodisBottle,
    record: .sodisBottle,
  ),
  prefilter(
    ingredients: {GameMaterial.cloth: 1},
    result: .prefilter,
    record: .prefilter,
  ),
  cookingPot(
    ingredients: {GameMaterial.metal: 1},
    result: .cookingPot,
    record: .cookingPot,
  ),
  rocketStove(
    ingredients: {GameMaterial.metal: 3},
    result: .rocketStove,
    record: .rocketStove,
    construction: .rocketStove,
  ),
  waterFilter(
    ingredients: {
      GameMaterial.plastic: 1,
      GameMaterial.cloth: 1,
      GameMaterial.sand: 1,
      GameMaterial.charcoal: 1,
    },
    result: .waterFilter,
    record: .waterFilter,
    construction: .waterFilter,
  );

  final Map<GameMaterial, int> ingredients;
  final InventoryItem result;
  final BookRecord record;
  final Construction? construction;

  const WorkbenchRecipe({
    required this.ingredients,
    required this.result,
    required this.record,
    this.construction,
  });

  bool isMadeFrom(Map<GameMaterial, int> materials) =>
      materials.length == ingredients.length &&
      ingredients.entries.every((entry) => materials[entry.key] == entry.value);

  static WorkbenchRecipe? fromMaterials(Map<GameMaterial, int> materials) =>
      values.where((recipe) => recipe.isMadeFrom(materials)).firstOrNull;
}
