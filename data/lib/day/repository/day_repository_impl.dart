import 'dart:async';

import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/day/repository/day_repository.dart';

final class DayRepositoryImpl implements DayRepository {
  final _dayController = StreamController<GameDay>.broadcast();
  final _outcomeController = StreamController<LevelOutcome?>.broadcast();
  GameDay _day = const .first();
  LevelOutcome? _outcome;

  @override
  GameDay get day => _day;

  @override
  Stream<GameDay> get dayStream => _dayController.stream;

  @override
  LevelOutcome? get outcome => _outcome;

  @override
  Stream<LevelOutcome?> get outcomeStream => _outcomeController.stream;

  @override
  void setDay(GameDay day) => _updateDay(day);

  @override
  void setOutcome(LevelOutcome outcome) => _updateOutcome(outcome);

  @override
  void restore(GameDay day) {
    _updateOutcome(null);
    _updateDay(day);
  }

  @override
  void reset() => restore(const .first());

  void _updateDay(GameDay day) {
    _day = day;
    _dayController.add(day);
  }

  void _updateOutcome(LevelOutcome? outcome) {
    _outcome = outcome;
    _outcomeController.add(outcome);
  }
}
