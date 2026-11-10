import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/time_speed/repository/time_speed_repository.dart';

final class SetTimeSpeedUseCase {
  final DayRepository _dayRepository;
  final TimeSpeedRepository _timeSpeedRepository;

  const SetTimeSpeedUseCase({
    required this._dayRepository,
    required this._timeSpeedRepository,
  });

  void call(bool isFast) => _timeSpeedRepository.setFast(isFast && !_dayRepository.day.isNight);
}
