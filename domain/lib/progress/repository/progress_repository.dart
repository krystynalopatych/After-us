import 'package:domain/progress/model/game_level.dart';

abstract interface class ProgressRepository {
  GameLevel get unlockedLevel;

  void reset();

  void completeLevel(GameLevel level);
}
