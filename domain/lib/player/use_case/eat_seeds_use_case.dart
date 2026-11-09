import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';

final class EatSeedsUseCase {
  static const _seedHunger = 5.0;

  final DialogueRepository _dialogueRepository;
  final FeedbackRepository _feedbackRepository;
  final HeroReactionRepository _heroReactionRepository;
  final MaterialRepository _materialRepository;
  final PlayerRepository _playerRepository;
  final SelectionRepository _selectionRepository;
  final SoundRepository _soundRepository;

  const EatSeedsUseCase({
    required this._dialogueRepository,
    required this._feedbackRepository,
    required this._heroReactionRepository,
    required this._materialRepository,
    required this._playerRepository,
    required this._selectionRepository,
    required this._soundRepository,
  });

  bool call() {
    if (!_materialRepository.remove(
      .seeds,
      1,
    )) {
      return false;
    }
    final stats = _playerRepository.stats;
    _playerRepository.setStats(
      stats.copyWith(
        hunger: (stats.hunger + _seedHunger).clamp(
          0.0,
          PlayerStats.maxNeed,
        ),
      ),
    );
    if (_materialRepository.count(.seeds) == 0) {
      _selectionRepository.reset();
    }
    _soundRepository.play(.eating);
    _feedbackRepository.show(
      const FeedbackMessage(
        text: 'You ate a seed +5 hunger Nothing will grow from it now',
        mood: .sad,
      ),
    );
    if (_heroReactionRepository.hear(.seedsEaten)) {
      _dialogueRepository.say(HeroReaction.seedsEaten.line);
    }
    return true;
  }
}
