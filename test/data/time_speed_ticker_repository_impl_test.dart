import 'package:data/time_speed/repository/time_speed_repository_impl.dart';
import 'package:data/time_speed/repository/time_speed_ticker_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ticks once every second at normal speed',
    () async {
      var ticks = 0;
      final subscription = TimeSpeedTickerRepositoryImpl(TimeSpeedRepositoryImpl()).seconds.listen((_) => ticks++);

      await Future<void>.delayed(const Duration(milliseconds: 2300));
      await subscription.cancel();

      expect(
        ticks,
        2,
      );
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );

  test(
    'ticks four times every second when time is fast',
    () async {
      var ticks = 0;
      final timeSpeed = TimeSpeedRepositoryImpl()..setFast(true);
      final subscription = TimeSpeedTickerRepositoryImpl(timeSpeed).seconds.listen((_) => ticks++);

      await Future<void>.delayed(const Duration(milliseconds: 1100));
      await subscription.cancel();

      expect(
        ticks,
        4,
      );
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );
}
