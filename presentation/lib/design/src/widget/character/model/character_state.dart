import 'package:presentation/generated/assets/assets.gen.dart';

enum CharacterState {
  normal,
  happy,
  sad;

  AssetGenImage get image => switch (this) {
    normal => Assets.resources.assets.images.imgMainCharacter,
    happy => Assets.resources.assets.images.imgMainCharacterHappy,
    sad => Assets.resources.assets.images.imgMainCharacterSad,
  };
}
