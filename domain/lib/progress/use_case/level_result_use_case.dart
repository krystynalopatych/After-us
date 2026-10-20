import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/model/level_result.dart';

final class LevelResultUseCase {
  final ConstructionRepository _constructionRepository;
  final DayRepository _dayRepository;

  const LevelResultUseCase({
    required this._constructionRepository,
    required this._dayRepository,
  });

  LevelResult? result(GameLevel level) {
    final outcome = _dayRepository.outcome;
    if (outcome == null) {
      return null;
    }
    final built = _constructionRepository.built;
    return LevelResult(
      outcome: outcome,
      missingGoals: [
        for (final goal in level.goals)
          if (!built.contains(goal)) goal,
      ],
    );
  }

  Stream<LevelResult?> resultStream(GameLevel level) => _dayRepository.outcomeStream.map((_) => result(level));
}
