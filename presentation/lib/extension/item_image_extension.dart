import 'package:domain/inventory/model/inventory_item.dart';
import 'package:flutter/widgets.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

extension InventoryItemImageExtension on InventoryItem {
  AssetGenImage asset(BuildContext context) {
    final images = context.images;
    return switch (this) {
      .cattailRoot => images.imgKoreniKamyshaSyrye,
      .cattailRootCooked => images.imgKoreniKamyshaSvarenye,
      .algae => images.imgSeaweedNEVymochenye,
      .algaeSoaked => images.imgSeaweedVymochenye,
      .berries => images.imgBerries,
      .mushrooms => images.imgMushroomsSyrye,
      .mushroomsCooked => images.imgMushroomsCooked,
      .potato => images.imgPotato,
      .potatoBoiled => images.imgBoiledPotato,
      .cleanWater => images.imgBoiledWater,
      .sodisLakeWater => images.imgSodisLakeWater,
      .bottleLakeWater => images.imgBottleLakeWater,
      .sodisStrainedWater => images.imgSodisStrainedWater,
      .bottleStrainedWater => images.imgBottleStrainedWater,
      .sodisFilteredWater => images.imgSodisFilteredWater,
      .bottleFilteredWater => images.imgBottleFilteredWater,
      .sodisCleanWater => images.imgSodisCleanWater,
      .sodisBottle => images.imgWaterSodis,
      .prefilter => images.imgPrefilter,
      .cookingPot => images.imgCookingPot,
      .rocketStove => images.imgRocketFire,
      .waterFilter => images.imgFullWaterFilter,
      .clayFridge => images.imgFreezerGorshok,
      .gardenBed => images.imgGryadka,
      .greenhouse => images.imgGreenhouse,
    };
  }
}
