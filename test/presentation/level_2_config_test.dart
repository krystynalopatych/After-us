import 'package:data/pickup/repository/pickup_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/level_2/model/level_2_config.dart';

void main() {
  test(
    'every level 2 pickup has a screen spot',
    () {
      final pickups = (PickupRepositoryImpl()..startLevel(.level2)).pickups;

      expect(
        Level2Config.pickupSpots,
        hasLength(pickups.length),
      );
    },
  );
}
