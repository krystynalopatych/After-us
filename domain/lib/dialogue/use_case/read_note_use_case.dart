import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';

final class ReadNoteUseCase {
  final DialogueRepository _dialogueRepository;
  final HeroReactionRepository _heroReactionRepository;

  const ReadNoteUseCase({
    required this._dialogueRepository,
    required this._heroReactionRepository,
  });

  void call() {
    if (_heroReactionRepository.hear(.survivorsNote)) {
      _dialogueRepository.say(HeroReaction.survivorsNote.line);
    }
  }
}
