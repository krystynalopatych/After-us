import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/widgets.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/location_image_extension.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

extension GameLevelImageExtension on GameLevel {
  List<AssetGenImage> images(BuildContext context) {
    final otherLevelPaths = {
      for (final level in GameLevel.values)
        if (level != this) ...[
          level.farLocation.background(context).path,
          level.farLocation.icon(context).path,
        ],
    };
    return [
      for (final image in context.images.values)
        if (!otherLevelPaths.contains(image.path)) image,
    ];
  }
}
