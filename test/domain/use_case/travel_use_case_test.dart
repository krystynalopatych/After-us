import 'package:data/location/repository/location_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/use_case/travel_use_case.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocationRepositoryImpl location;
  late PlayerRepositoryImpl player;
  late TravelUseCase travel;

  setUp(() {
    location = LocationRepositoryImpl();
    player = PlayerRepositoryImpl();
    travel = TravelUseCase(
      locationRepository: location,
      playerRepository: player,
    );
  });

  test(
    'moves the player to the destination',
    () {
      travel(.lake);

      expect(
        location.location,
        GameLocation.lake,
      );
    },
  );

  test(
    'trips between near locations cost no thirst',
    () {
      travel(.forest);
      travel(.lake);
      travel(.house);

      expect(
        player.stats.thirst,
        80,
      );
    },
  );

  test(
    'a trip to the far zone and back costs 10 thirst each way',
    () {
      travel(.dump);
      expect(
        player.stats.thirst,
        70,
      );

      travel(.forest);
      expect(
        player.stats.thirst,
        60,
      );
    },
  );

  test(
    'staying at the far zone costs nothing',
    () {
      travel(.dump);
      travel(.dump);

      expect(
        player.stats.thirst,
        70,
      );
    },
  );

  test(
    'thirst never goes below zero',
    () {
      player.setStats(
        const PlayerStats(
          health: 100,
          hunger: 80,
          thirst: 4,
        ),
      );
      travel(.dump);

      expect(
        player.stats.thirst,
        0,
      );
    },
  );

  test(
    'the far trip keeps health, hunger and the health ceiling',
    () {
      player.setStats(
        const PlayerStats(
          health: 55,
          hunger: 33,
          thirst: 50,
          healthCeiling: 85,
        ),
      );
      travel(.dump);

      expect(
        player.stats,
        const PlayerStats(
          health: 55,
          hunger: 33,
          thirst: 40,
          healthCeiling: 85,
        ),
      );
    },
  );
}
