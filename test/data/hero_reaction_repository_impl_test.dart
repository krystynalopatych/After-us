import 'package:data/dialogue/repository/hero_reaction_repository_impl.dart';
import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'hear returns true only the first time a reaction is heard',
    () {
      final repository = HeroReactionRepositoryImpl();

      expect(
        repository.hear(.darkSky),
        isTrue,
      );
      expect(
        repository.hear(.darkSky),
        isFalse,
      );
      expect(
        repository.heard,
        {HeroReaction.darkSky},
      );
    },
  );

  test(
    'reset forgets every heard reaction',
    () {
      final repository = HeroReactionRepositoryImpl()
        ..hear(.lakePolluted)
        ..hear(.dirtyAir)
        ..reset();

      expect(
        repository.heard,
        isEmpty,
      );
    },
  );
}
