import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/station/model/station.dart';

enum CampfireRecipe {
  boilSodisLakeWater(
    input: .sodisLakeWater,
    output: .cleanWater,
    outputCount: 2,
    stoveOutputCount: 3,
  ),
  boilBottleLakeWater(
    input: .bottleLakeWater,
    output: .cleanWater,
    outputCount: 2,
    stoveOutputCount: 3,
  ),
  boilSodisStrainedWater(
    input: .sodisStrainedWater,
    output: .cleanWater,
    outputCount: 2,
    stoveOutputCount: 3,
  ),
  boilBottleStrainedWater(
    input: .bottleStrainedWater,
    output: .cleanWater,
    outputCount: 2,
    stoveOutputCount: 3,
  ),
  cookCattailRoot(
    input: .cattailRoot,
    output: .cattailRootCooked,
    stoveOutputCount: 2,
  ),
  makeCharcoal(
    material: .wood,
    product: .charcoal,
  );

  final InventoryItem? input;
  final InventoryItem? output;
  final int outputCount;
  final int stoveOutputCount;
  final GameMaterial? material;
  final GameMaterial? product;

  const CampfireRecipe({
    this.input,
    this.output,
    this.outputCount = 1,
    this.stoveOutputCount = 1,
    this.material,
    this.product,
  });

  int outputCountOn(Station station) => station == .rocketStove ? stoveOutputCount : outputCount;

  List<InventoryItem> outputsOn(Station station) => [
    if (output case final output?)
      ...List.filled(
        outputCountOn(station),
        output,
      ),
    ?input?.emptyBottle,
  ];

  static CampfireRecipe? fromItem(InventoryItem item) => values.where((recipe) => recipe.input == item).firstOrNull;

  static CampfireRecipe? fromMaterial(GameMaterial material) =>
      values.where((recipe) => recipe.material == material).firstOrNull;
}
