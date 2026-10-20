import 'dart:async';

import 'package:domain/day/repository/day_repository.dart';

final class DayRepositoryImpl implements DayRepository {
  static const _firstDay = 1;

  final _dayController = StreamController<int>.broadcast();
  int _day = _firstDay;

  @override
  int get day => _day;

  @override
  Stream<int> get dayStream => _dayController.stream;

  @override
  void nextDay() => _update(_day + 1);

  @override
  void restore(int day) => _update(day);

  @override
  void reset() => _update(_firstDay);

  void _update(int day) {
    _day = day;
    _dayController.add(day);
  }
}
