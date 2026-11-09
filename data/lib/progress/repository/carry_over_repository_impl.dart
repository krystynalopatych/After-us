import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/model/level_carry_over.dart';
import 'package:domain/progress/repository/carry_over_repository.dart';

final class CarryOverRepositoryImpl implements CarryOverRepository {
  final _carryOvers = <GameLevel, LevelCarryOver>{};

  @override
  LevelCarryOver carryOver(GameLevel level) => _carryOvers[level] ?? const .none();

  @override
  void keep(
    GameLevel level,
    LevelCarryOver carryOver,
  ) => _carryOvers[level] = carryOver;

  @override
  void reset() => _carryOvers.clear();
}
