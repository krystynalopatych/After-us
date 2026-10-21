import 'package:data/sun_spot/repository/sun_spot_repository_impl.dart';
import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ticks a placed bottle until it is ready and then stops',
    () {
      final repository = SunSpotRepositoryImpl()..tick();

      expect(
        repository.bottle,
        isNull,
      );

      repository.place(const SunBottle(item: .sodisStrainedWater));
      for (var i = 0; i < SunBottle.readySeconds + 10; i++) {
        repository.tick();
      }

      expect(
        repository.bottle?.seconds,
        SunBottle.readySeconds,
      );
      expect(
        repository.bottle?.progress,
        1.0,
      );

      repository.take();
      expect(
        repository.bottle,
        isNull,
      );
    },
  );
}
