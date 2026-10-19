import 'package:presentation/generated/assets/assets.gen.dart';

enum CharacterState {
  normal,
  happy,
  sad;

  AssetGenImage get image => switch (this) {
    normal => Assets.images.characterNormal,
    happy => Assets.images.characterHappy,
    sad => Assets.images.characterSad,
  };
}
