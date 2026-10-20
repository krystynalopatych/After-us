import 'package:data/day/repository/ticker_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ticks once every second',
    () async {
      var ticks = 0;
      final subscription = TickerRepositoryImpl().seconds.listen((_) => ticks++);

      await Future<void>.delayed(const Duration(milliseconds: 2300));
      await subscription.cancel();

      expect(
        ticks,
        2,
      );
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );
}
