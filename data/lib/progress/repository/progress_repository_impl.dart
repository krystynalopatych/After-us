import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';

final class ProgressRepositoryImpl implements ProgressRepository {
  GameLevel _unlockedLevel = .level1;

  @override
  GameLevel get unlockedLevel => _unlockedLevel;

  @override
  void reset() => _unlockedLevel = .level1;

  @override
  void completeLevel(GameLevel level) {
    final nextIndex = level.index + 1;
    if (nextIndex < GameLevel.values.length && nextIndex > _unlockedLevel.index) {
      _unlockedLevel = GameLevel.values[nextIndex];
    }
  }
}
