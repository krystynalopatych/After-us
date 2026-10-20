import 'package:data/location/repository/location_repository_impl.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts at home and emits every new location',
    () async {
      final repository = LocationRepositoryImpl();
      final locations = <GameLocation>[];
      final subscription = repository.locationStream.listen(locations.add);
      addTearDown(subscription.cancel);

      expect(
        repository.location,
        GameLocation.house,
      );

      repository
        ..setLocation(.lake)
        ..setLocation(.dump);
      await pumpEventQueue();

      expect(
        repository.location,
        GameLocation.dump,
      );
      expect(
        locations,
        [GameLocation.lake, GameLocation.dump],
      );
    },
  );
}
