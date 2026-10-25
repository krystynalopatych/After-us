import 'package:domain/inventory/model/water_kind.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/station/model/station.dart';
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
    bloc.add(const GameMapClosed());
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
    'tapping the location opens the build dialog only for a material that builds a station',
    () async {
      bloc.add(const GameLocationTapped());
      await pumpEventQueue();
      expect(
        bloc.state.isBuildOpen,
        isFalse,
      );

      deps.selection.selectMaterial(.plastic);
      bloc.add(const GameLocationTapped());
      await pumpEventQueue();
      expect(
        bloc.state.isBuildOpen,
        isFalse,
      );

      deps.selection.selectMaterial(.wood);
      bloc.add(const GameLocationTapped());
      await pumpEventQueue();
      expect(
        bloc.state.isBuildOpen,
        isTrue,
      );

      bloc.add(const GameBuildClosed());
      await pumpEventQueue();
      expect(
        bloc.state.isBuildOpen,
        isFalse,
      );
    },
  );

  test(
    'choosing a location moves the player under the open map until the page closes it',
    () async {
      bloc.add(const GameMapTapped());
      await pumpEventQueue();
      bloc.add(const GameLocationSelected(.lake));
      await pumpEventQueue();

      expect(
        bloc.state,
        const GameState(
          location: .lake,
          isMapOpen: true,
          isTraveling: true,
        ),
      );
      expect(
        deps.location.location,
        GameLocation.lake,
      );

      bloc.add(const GameMapClosed());
      await pumpEventQueue();
      expect(
        bloc.state,
        const GameState(location: .lake),
      );
    },
  );

  test(
    'choosing another location while traveling is ignored',
    () async {
      bloc.add(const GameMapTapped());
      await pumpEventQueue();
      bloc.add(const GameLocationSelected(.lake));
      bloc.add(const GameLocationSelected(.forest));
      await pumpEventQueue();

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

  test(
    'tapping the lake water fills the selected SODIS bottle',
    () async {
      deps.inventory.add(.sodisBottle);
      bloc.add(const GameLakeWaterTapped());
      await pumpEventQueue();
      expect(
        deps.inventory.count(.sodisLakeWater),
        0,
      );

      deps.selection.selectSlot(0);
      bloc.add(const GameLakeWaterTapped());
      await pumpEventQueue();
      expect(
        deps.inventory.count(.sodisLakeWater),
        1,
      );
    },
  );

  test(
    'tapping the lake water with a filter asks where to store the water',
    () async {
      deps.inventory.add(.prefilter);
      deps.selection.selectSlot(0);

      bloc.add(const GameLakeWaterTapped());
      await pumpEventQueue();
      expect(
        bloc.state.waterChoice,
        WaterKind.strained,
      );

      bloc.add(const GameWaterChoiceClosed());
      await pumpEventQueue();
      expect(
        bloc.state.waterChoice,
        isNull,
      );
    },
  );

  test(
    'choosing a location never shows the old location with the map closed',
    () async {
      bloc.add(const GameMapTapped());
      await pumpEventQueue();
      final states = <GameState>[];
      final subscription = bloc.stream.listen(states.add);
      addTearDown(subscription.cancel);

      await travel(.lake);

      expect(
        states.first,
        const GameState(
          location: .lake,
          isMapOpen: true,
          isTraveling: true,
        ),
      );
      expect(
        states.where((state) => !state.isMapOpen && state.location == .house),
        isEmpty,
      );
    },
  );

  test(
    'tapping the campfire opens and closes the campfire window',
    () async {
      bloc.add(const GameStationTapped(.campfire));
      await pumpEventQueue();
      expect(
        bloc.state.fireStation,
        Station.campfire,
      );

      bloc.add(const GameFireClosed());
      await pumpEventQueue();
      expect(
        bloc.state.fireStation,
        isNull,
      );
    },
  );

  test(
    'tapping the workbench opens and closes the workbench window',
    () async {
      bloc.add(const GameStationTapped(.workbench));
      await pumpEventQueue();
      expect(
        bloc.state.isWorkbenchOpen,
        isTrue,
      );
      expect(
        bloc.state.isStationOpen,
        isTrue,
      );

      bloc.add(const GameWorkbenchClosed());
      await pumpEventQueue();
      expect(
        bloc.state.isWorkbenchOpen,
        isFalse,
      );
    },
  );

  test(
    'tapping the house with the rocket stove selected sets it up and opens no build dialog',
    () async {
      deps.inventory.add(.rocketStove);
      deps.selection.selectSlot(0);

      bloc.add(const GameLocationTapped());
      await pumpEventQueue();

      expect(
        deps.station.built,
        {Station.rocketStove},
      );
      expect(
        bloc.state.isBuildOpen,
        isFalse,
      );

      bloc.add(const GameStationTapped(.rocketStove));
      await pumpEventQueue();
      expect(
        bloc.state.fireStation,
        Station.rocketStove,
      );
    },
  );

  test(
    'the book opens and closes',
    () async {
      bloc.add(const GameBookTapped());
      await pumpEventQueue();
      expect(
        bloc.state.isBookOpen,
        isTrue,
      );

      bloc.add(const GameBookClosed());
      await pumpEventQueue();
      expect(
        bloc.state.isBookOpen,
        isFalse,
      );
    },
  );

  test(
    'time stands still while the map is open',
    () async {
      bloc.add(const GameMapTapped());
      await pumpEventQueue();
      expect(
        deps.clock.isPaused,
        isTrue,
      );

      bloc.add(const GameMapClosed());
      await pumpEventQueue();
      expect(
        deps.clock.isPaused,
        isFalse,
      );

      bloc.add(const GameMapTapped());
      await pumpEventQueue();
      await travel(.lake);
      expect(
        deps.clock.isPaused,
        isFalse,
      );
    },
  );
}
