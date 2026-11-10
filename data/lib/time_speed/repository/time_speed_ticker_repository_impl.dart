import 'package:domain/day/repository/ticker_repository.dart';
import 'package:domain/time_speed/repository/time_speed_repository.dart';

final class TimeSpeedTickerRepositoryImpl implements TickerRepository {
  static const _fastFactor = 4;
  static const _interval = Duration(milliseconds: 1000 ~/ _fastFactor);

  final TimeSpeedRepository _timeSpeedRepository;

  const TimeSpeedTickerRepositoryImpl(this._timeSpeedRepository);

  @override
  Stream<void> get seconds {
    var slowTicks = 0;
    return Stream<void>.periodic(_interval).where(
      (_) => _timeSpeedRepository.isFast || ++slowTicks % _fastFactor == 0,
    );
  }
}
