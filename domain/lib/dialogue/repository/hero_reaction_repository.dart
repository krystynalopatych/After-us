import 'package:domain/dialogue/model/hero_reaction.dart';

abstract interface class HeroReactionRepository {
  Set<HeroReaction> get heard;

  bool hear(HeroReaction reaction);

  void reset();
}
