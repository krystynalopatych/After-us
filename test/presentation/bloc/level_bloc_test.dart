import 'package:domain/character/model/character_mood.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/station/model/station.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/level_1/bloc/level_1_bloc.dart';
import 'package:presentation/feature/level_2/bloc/level_2_bloc.dart';
import 'package:presentation/feature/level_3/bloc/level_3_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  GameSave save(GameLevel level) => GameSave(
    level: level,
    location: .lake,
    savedAt: DateTime(
      2026,
      10,
      20,
    ),
    day: const GameDay(
      number: 2,
      seconds: 100,
    ),
    stats: const PlayerStats(
      health: 60,
      hunger: 30,
      thirst: 20,
      healthCeiling: 90,
    ),
    materials: const [
      MaterialStock(
        material: .sand,
        count: 2,
      ),
    ],
    inventory: const [
      InventoryStack(
        item: .algae,
        count: 4,
      ),
    ],
    pickups: const [
      Pickup(
        id: 3,
        location: .lake,
        kind: .cattail,
      ),
    ],
    pollution: const Pollution(
      airPoints: 5,
      isWaterPolluted: true,
      isSoilPolluted: true,
    ),
    constructions: const {.waterFilter},
    stations: const {.campfire},
  );

  void dirtyEverything() {
    deps.character.setMood(.sad);
    deps.day
      ..setDay(
        const GameDay(
          number: 3,
          seconds: 400,
        ),
      )
      ..setOutcome(.died);
    deps.player.setStats(
      const PlayerStats(
        health: 10,
        hunger: 0,
        thirst: 0,
      ),
    );
    deps.material.add(.metal);
    deps.inventory.add(.berries);
    deps.pollution
      ..addAirPoints(8)
      ..polluteWater();
    deps.construction.build(.compostPit);
    deps.station.build(.workbench);
    deps.location.setLocation(.dump);
  }

  void expectFreshLevel(GameLevel level) {
    expect(
      deps.character.mood,
      CharacterMood.normal,
    );
    expect(
      deps.day.day.number,
      1,
    );
    expect(
      deps.day.day.seconds,
      0,
    );
    expect(
      deps.day.outcome,
      isNull,
    );
    expect(
      deps.player.stats.health,
      100,
    );
    expect(
      deps.player.stats.thirst,
      80,
    );
    expect(
      deps.material.stocks,
      isEmpty,
    );
    expect(
      deps.inventory.stacks,
      isEmpty,
    );
    expect(
      deps.pollution.pollution.airPoints,
      0,
    );
    expect(
      deps.pollution.pollution.isWaterPolluted,
      isFalse,
    );
    expect(
      deps.construction.built,
      isEmpty,
    );
    expect(
      deps.station.built,
      isEmpty,
    );
    expect(
      deps.location.location,
      GameLocation.house,
    );
    expect(
      deps.pickup.pickups.isEmpty,
      level != .level1,
    );
  }

  void expectRestored() {
    expect(
      deps.character.mood,
      CharacterMood.normal,
    );
    expect(
      deps.day.day.number,
      2,
    );
    expect(
      deps.day.day.seconds,
      100,
    );
    expect(
      deps.day.outcome,
      isNull,
    );
    expect(
      deps.player.stats.health,
      60,
    );
    expect(
      deps.player.stats.healthCeiling,
      90,
    );
    expect(
      deps.material.stocks.single.count,
      2,
    );
    expect(
      deps.inventory.stacks.single.count,
      4,
    );
    expect(
      deps.pickup.pickups.single.id,
      3,
    );
    expect(
      deps.pollution.pollution.airPoints,
      5,
    );
    expect(
      deps.pollution.pollution.isSoilPolluted,
      isTrue,
    );
    expect(
      deps.construction.built,
      {Construction.waterFilter},
    );
    expect(
      deps.station.built,
      {Station.campfire},
    );
    expect(
      deps.location.location,
      GameLocation.lake,
    );
  }

  group(
    'Level1Bloc',
    () {
      test(
        'a new game resets everything and lays out level 1 resources',
        () async {
          dirtyEverything();
          final bloc = Level1Bloc()..add(const Level1Started());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expectFreshLevel(.level1);
          expect(
            deps.pickup.pickups,
            hasLength(39),
          );
        },
      );

      test(
        'a loaded level 1 save restores everything',
        () async {
          dirtyEverything();
          deps.save.load(save(.level1));
          final bloc = Level1Bloc()..add(const Level1Started());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expectRestored();
          expect(
            deps.save.takeLoadedSave(),
            isNull,
          );
        },
      );

      test(
        'a save for another level is ignored and the level starts fresh',
        () async {
          deps.save.load(save(.level2));
          final bloc = Level1Bloc()..add(const Level1Started());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expectFreshLevel(.level1);
          expect(
            deps.save.takeLoadedSave(),
            isNull,
          );
        },
      );
    },
  );

  group(
    'Level2Bloc',
    () {
      test(
        'a new game resets everything',
        () async {
          dirtyEverything();
          final bloc = Level2Bloc()..add(const Level2Started());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expectFreshLevel(.level2);
        },
      );

      test(
        'a loaded level 2 save restores everything',
        () async {
          deps.save.load(save(.level2));
          final bloc = Level2Bloc()..add(const Level2Started());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expectRestored();
        },
      );
    },
  );

  group(
    'Level3Bloc',
    () {
      test(
        'a new game resets everything',
        () async {
          dirtyEverything();
          final bloc = Level3Bloc()..add(const Level3Started());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expectFreshLevel(.level3);
        },
      );

      test(
        'a loaded level 3 save restores everything',
        () async {
          deps.save.load(save(.level3));
          final bloc = Level3Bloc()..add(const Level3Started());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expectRestored();
        },
      );
    },
  );
}
