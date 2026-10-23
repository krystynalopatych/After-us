import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';

final class HeroReactionRepositoryImpl implements HeroReactionRepository {
  final _heard = <HeroReaction>{};

  @override
  Set<HeroReaction> get heard => Set.unmodifiable(_heard);

  @override
  bool hear(HeroReaction reaction) => _heard.add(reaction);

  @override
  void reset() => _heard.clear();
}
