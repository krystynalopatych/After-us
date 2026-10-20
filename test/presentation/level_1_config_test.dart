import 'package:data/pickup/repository/pickup_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/level_1/model/level_1_config.dart';

void main() {
  test(
    'every level 1 pickup has a screen spot',
    () {
      final pickups = (PickupRepositoryImpl()..startLevel(.level1)).pickups;

      expect(
        Level1Config.pickupSpots,
        hasLength(pickups.length),
      );
    },
  );
}
