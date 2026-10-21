import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';

enum CampfireRecipe {
  boilWater(
    input: .lakeWater,
    output: .cleanWater,
    outputCount: 2,
  ),
  cookCattailRoot(
    input: .cattailRoot,
    output: .cattailRootCooked,
  ),
  makeCharcoal(
    material: .wood,
    product: .charcoal,
  );

  final InventoryItem? input;
  final InventoryItem? output;
  final int outputCount;
  final GameMaterial? material;
  final GameMaterial? product;

  const CampfireRecipe({
    this.input,
    this.output,
    this.outputCount = 1,
    this.material,
    this.product,
  });

  static CampfireRecipe? fromItem(InventoryItem item) => values.where((recipe) => recipe.input == item).firstOrNull;

  static CampfireRecipe? fromMaterial(GameMaterial material) =>
      values.where((recipe) => recipe.material == material).firstOrNull;
}
