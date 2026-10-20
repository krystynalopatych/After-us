import 'package:domain/location/model/game_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/game/bloc/game_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late GameBloc bloc;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    bloc = GameBloc()..add(const GameStarted());
    await pumpEventQueue();
  });

  tearDown(() => bloc.close());

  Future<void> travel(GameLocation location) async {
    bloc.add(GameLocationSelected(location));
    await pumpEventQueue();
  }

  test(
    'starts at the stored location with the map closed',
    () {
      expect(
        bloc.state.location,
        GameLocation.house,
      );
      expect(
        bloc.state.isMapOpen,
        isFalse,
      );
    },
  );

  test(
    'opens and closes the map',
    () async {
      bloc.add(const GameMapTapped());
      await pumpEventQueue();
      expect(
        bloc.state.isMapOpen,
        isTrue,
      );

      bloc.add(const GameMapClosed());
      await pumpEventQueue();
      expect(
        bloc.state.isMapOpen,
        isFalse,
      );
      expect(
        bloc.state.location,
        GameLocation.house,
      );
    },
  );

  test(
    'choosing a location closes the map and moves the player',
    () async {
      bloc.add(const GameMapTapped());
      await pumpEventQueue();
      await travel(.lake);

      expect(
        bloc.state.isMapOpen,
        isFalse,
      );
      expect(
        bloc.state.location,
        GameLocation.lake,
      );
      expect(
        deps.location.location,
        GameLocation.lake,
      );
    },
  );

  test(
    'trips between near locations cost no thirst',
    () async {
      await travel(.forest);
      await travel(.lake);
      await travel(.house);

      expect(
        deps.player.stats.thirst,
        80,
      );
    },
  );

  test(
    'a trip to the far zone and back costs 10 thirst each way',
    () async {
      await travel(.dump);
      expect(
        deps.player.stats.thirst,
        70,
      );

      await travel(.forest);
      expect(
        deps.player.stats.thirst,
        60,
      );
    },
  );

  test(
    'staying at the far zone costs nothing and thirst never goes below zero',
    () async {
      await travel(.dump);
      await travel(.dump);
      expect(
        deps.player.stats.thirst,
        70,
      );

      deps.player.setStats(const .initial());
      deps.player.setStats(
        const .new(
          health: 100,
          hunger: 80,
          thirst: 4,
        ),
      );
      await travel(.house);

      expect(
        deps.player.stats.thirst,
        0,
      );
    },
  );

  test(
    'the far trip keeps health, hunger and the health ceiling',
    () async {
      deps.player.setStats(
        const .new(
          health: 55,
          hunger: 33,
          thirst: 50,
          healthCeiling: 85,
        ),
      );
      await travel(.dump);

      expect(
        deps.player.stats.health,
        55,
      );
      expect(
        deps.player.stats.hunger,
        33,
      );
      expect(
        deps.player.stats.healthCeiling,
        85,
      );
      expect(
        deps.player.stats.thirst,
        40,
      );
    },
  );
}
