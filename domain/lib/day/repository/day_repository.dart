import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/model/level_outcome.dart';

abstract interface class DayRepository {
  GameDay get day;

  Stream<GameDay> get dayStream;

  LevelOutcome? get outcome;

  Stream<LevelOutcome?> get outcomeStream;

  void setDay(GameDay day);

  void setOutcome(LevelOutcome outcome);

  void restore(GameDay day);

  void reset();
}
