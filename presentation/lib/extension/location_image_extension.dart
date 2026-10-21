import 'package:domain/location/model/game_location.dart';
import 'package:flutter/widgets.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

extension GameLocationImageExtension on GameLocation {
  AssetGenImage background(BuildContext context) {
    final images = context.images;
    return switch (this) {
      .house => images.imgHouseRectangle,
      .forest => images.imgForestRectangle,
      .lake => images.imgLakeRectangle,
      .dump => images.imgSvalka,
      .store => images.imgAbandonnedStore,
      .garage => images.imgGarage,
    };
  }

  AssetGenImage icon(BuildContext context) {
    final images = context.images;
    return switch (this) {
      .house => images.imgHomeIcon,
      .forest => images.imgForestIcon,
      .lake => images.imgLakeIcon,
      .dump => images.imgSvalkaIcon,
      .store => images.imgStoreIcon,
      .garage => images.imgGarageIcon,
    };
  }
}
