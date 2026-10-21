import 'package:domain/material/model/game_material.dart';
import 'package:flutter/widgets.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

extension GameMaterialImageExtension on GameMaterial {
  AssetGenImage asset(BuildContext context) {
    final images = context.images;
    return switch (this) {
      .plastic => images.imgPlasticBottle,
      .cloth => images.imgFabric,
      .sand => images.imgSand,
      .wood => images.imgWood,
      .metal => images.imgMetal,
      .organics => images.imgOrganic,
      .cardboard => images.imgCardboard,
      .seeds => images.imgSeeds,
      .clay => images.imgClay,
      .oil => images.imgOil,
      .chlorine => images.imgChlorine,
      .electronics => images.imgProvoda,
      .charcoal => images.imgCoal,
      .compost => images.imgKompost,
    };
  }
}
