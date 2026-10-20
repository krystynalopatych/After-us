import 'package:presentation/generated/assets/assets.gen.dart';

enum CharacterState {
  normal(aspectRatio: 842 / 1139),
  happy(aspectRatio: 1009 / 1226),
  sad(aspectRatio: 1228 / 1219);

  final double aspectRatio;

  const CharacterState({required this.aspectRatio});

  AssetGenImage get image => switch (this) {
    normal => Assets.resources.assets.images.imgMainCharacter,
    happy => Assets.resources.assets.images.imgMainCharacterHappy,
    sad => Assets.resources.assets.images.imgMainCharacterSad,
  };
}
