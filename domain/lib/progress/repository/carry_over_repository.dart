import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/model/level_carry_over.dart';

abstract interface class CarryOverRepository {
  LevelCarryOver carryOver(GameLevel level);

  void keep(
    GameLevel level,
    LevelCarryOver carryOver,
  );

  void reset();
}
