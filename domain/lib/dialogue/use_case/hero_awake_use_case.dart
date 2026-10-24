import 'package:domain/day/repository/day_repository.dart';

final class HeroAwakeUseCase {
  final DayRepository _dayRepository;

  const HeroAwakeUseCase({required this._dayRepository});

  bool get isAwake => !_dayRepository.day.isNight;

  Stream<bool> get isAwakeStream => _dayRepository.dayStream.map((day) => !day.isNight).distinct();
}
