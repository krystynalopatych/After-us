import 'package:domain/construction/model/construction.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/model/level_carry_over.dart';
import 'package:domain/progress/use_case/complete_level_use_case.dart';
import 'package:domain/progress/use_case/new_game_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late CompleteLevelUseCase completeLevel;
  late StartLevelUseCase startLevel;
  late NewGameUseCase newGame;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    completeLevel = diContainer.get();
    startLevel = diContainer.get();
    newGame = diContainer.get();
  });

  void playLevel1() {
    startLevel(.level1);
    deps.inventory
      ..add(.berries)
      ..add(.waterFilter);
    deps.material
      ..add(.wood)
      ..add(.compost);
    deps.construction
      ..build(.waterFilter)
      ..build(.compostPit)
      ..build(.rocketStove);
    deps.station
      ..build(.campfire)
      ..build(.workbench);
    deps.compost.addOrganics();
    deps.pollution.addAirPoints(3);
  }

  test(
    'level 2 starts with the inventory, constructions and stations won on level 1',
    () {
      playLevel1();
      completeLevel(.level1);

      startLevel(.level2);

      expect(
        deps.inventory.count(.berries),
        1,
      );
      expect(
        deps.inventory.count(.waterFilter),
        1,
      );
      expect(
        deps.construction.built,
        {Construction.waterFilter, Construction.compostPit, Construction.rocketStove},
      );
      expect(
        deps.station.built,
        {Station.campfire, Station.workbench},
      );
    },
  );

  test(
    'the counter, the compost pit and pollution start empty on level 2',
    () {
      playLevel1();
      completeLevel(.level1);

      startLevel(.level2);

      expect(
        deps.material.count(GameMaterial.compost),
        0,
      );
      expect(
        deps.material.stocks,
        isEmpty,
      );
      expect(
        deps.compost.pit.organics,
        0,
      );
      expect(
        deps.pollution.pollution.airPoints,
        0,
      );
    },
  );

  test(
    'a bottle left on the sun spot comes back empty',
    () {
      playLevel1();
      deps.sunSpot.place(const SunBottle(item: .sodisStrainedWater));

      completeLevel(.level1);
      startLevel(.level2);

      expect(
        deps.inventory.count(.sodisBottle),
        1,
      );
      expect(
        deps.inventory.count(.sodisStrainedWater),
        0,
      );
      expect(
        deps.sunSpot.bottle,
        isNull,
      );
    },
  );

  test(
    'a bottle on the sun spot is lost when the inventory is full',
    () {
      startLevel(.level1);
      for (final item in InventoryItem.values.take(12)) {
        deps.inventory.add(item);
      }
      deps.sunSpot.place(const SunBottle(item: .sodisStrainedWater));

      completeLevel(.level1);
      startLevel(.level2);

      expect(
        deps.inventory.count(.sodisBottle),
        0,
      );
    },
  );

  test(
    'retry on level 2 starts again with the same carry-over',
    () {
      playLevel1();
      completeLevel(.level1);
      startLevel(.level2);
      deps.inventory.remove(.berries);
      deps.construction.reset();

      startLevel(.level2);

      expect(
        deps.inventory.count(.berries),
        1,
      );
      expect(
        deps.construction.built,
        contains(Construction.waterFilter),
      );
    },
  );

  test(
    'the last win of a level decides what the next level gets',
    () {
      playLevel1();
      completeLevel(.level1);

      startLevel(.level1);
      deps.inventory.add(.algae);
      completeLevel(.level1);
      startLevel(.level2);

      expect(
        deps.inventory.count(.algae),
        1,
      );
      expect(
        deps.inventory.count(.berries),
        0,
      );
    },
  );

  test(
    'level 1 always starts with nothing',
    () {
      playLevel1();
      completeLevel(.level1);

      startLevel(.level1);

      expect(
        deps.inventory.stacks,
        isEmpty,
      );
      expect(
        deps.construction.built,
        isEmpty,
      );
      expect(
        deps.station.built,
        isEmpty,
      );
    },
  );

  test(
    'completing the last level keeps nothing',
    () {
      playLevel1();

      completeLevel(.level3);

      expect(
        deps.carryOver.carryOver(GameLevel.level3),
        const LevelCarryOver.none(),
      );
      expect(
        deps.inventory.count(.berries),
        1,
      );
    },
  );

  test(
    'a new game forgets the carry-over',
    () {
      playLevel1();
      completeLevel(.level1);

      newGame();
      startLevel(.level2);

      expect(
        deps.inventory.stacks,
        isEmpty,
      );
      expect(
        deps.construction.built,
        isEmpty,
      );
    },
  );
}
