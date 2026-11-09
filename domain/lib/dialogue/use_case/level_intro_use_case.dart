import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/progress/model/game_level.dart';

final class LevelIntroUseCase {
  final DialogueRepository _dialogueRepository;
  final HeroReactionRepository _heroReactionRepository;

  const LevelIntroUseCase({
    required this._dialogueRepository,
    required this._heroReactionRepository,
  });

  void call(GameLevel level) {
    final intro = switch (level) {
      .level2 => HeroReaction.level2Intro,
      .level1 || .level3 => null,
    };
    if (intro != null && _heroReactionRepository.hear(intro)) {
      _dialogueRepository.say(intro.line);
    }
  }
}
