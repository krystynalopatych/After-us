import 'package:domain/day/repository/clock_repository.dart';

final class ClockRepositoryImpl implements ClockRepository {
  var _isPaused = false;

  @override
  bool get isPaused => _isPaused;

  @override
  void setPaused(bool isPaused) => _isPaused = isPaused;
}
