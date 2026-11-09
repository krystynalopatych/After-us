import 'package:data/mushroom/repository/mushroom_farm_repository_impl.dart';
import 'package:domain/book/model/book_record.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/mushroom/model/mushroom_farm.dart';
import 'package:domain/mushroom/use_case/soak_cardboard_use_case.dart';
import 'package:domain/mushroom/use_case/use_mushroom_farm_use_case.dart';
import 'package:domain/progress/use_case/complete_level_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/place_station_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';
import 'package:presentation/feature/game/bloc/game_bloc.dart';
import 'package:presentation/feature/mushroom/bloc/mushroom_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late List<FeedbackMessage> messages;
  late UseMushroomFarmUseCase useFarm;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    useFarm = diContainer.get();
    messages = [];
    final subscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(subscription.cancel);
  });

  void addMaterial(
    GameMaterial material,
    int count,
  ) {
    for (var i = 0; i < count; i++) {
      deps.material.add(material);
    }
  }

  void selectMushroom({int age = 0}) {
    deps.inventory.add(
      .mushrooms,
      age: age,
    );
    deps.selection.selectSlot(deps.inventory.stacks.indexWhere((stack) => stack.item == InventoryItem.mushrooms));
  }

  void plantFarm() {
    deps.mushroom.place();
    selectMushroom();
    useFarm();
  }

  void grow(int seconds) {
    final passSecond = diContainer.get<PassSecondUseCase>();
    for (var i = 0; i < seconds; i++) {
      passSecond(.level2);
    }
  }

  group(
    'soaking cardboard',
    () {
      test(
        'a tap on the lake with cardboard soaks one piece and writes the book record',
        () async {
          addMaterial(
            .cardboard,
            2,
          );
          deps.selection.selectMaterial(.cardboard);

          expect(
            diContainer.get<SoakCardboardUseCase>()(),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            deps.inventory.count(.wetCardboard),
            1,
          );
          expect(
            deps.material.count(.cardboard),
            1,
          );
          expect(
            deps.selection.selection.material,
            GameMaterial.cardboard,
          );
          expect(
            deps.book.book.records,
            [BookRecord.wetCardboard],
          );
          expect(
            messages.single.text,
            'You soaked cardboard in the lake +1 wet cardboard',
          );
        },
      );

      test(
        'without cardboard the lake tap fills bottles as before',
        () async {
          final bloc = GameBloc()..add(const GameStarted());
          addTearDown(bloc.close);
          await pumpEventQueue();
          deps.material.add(.plastic);
          deps.selection.selectMaterial(.plastic);

          expect(
            diContainer.get<SoakCardboardUseCase>()(),
            isFalse,
          );
          bloc.add(const GameLakeWaterTapped());
          await pumpEventQueue();

          expect(
            deps.inventory.count(.bottleLakeWater),
            1,
          );
        },
      );

      test(
        'two cardboard and any bottle of water soak at the workbench, the record is written once',
        () {
          final craft = diContainer.get<CraftUseCase>();
          deps.workbench
            ..setSlot(
              0,
              const WorkbenchItem.material(.cardboard),
            )
            ..setSlot(
              1,
              const WorkbenchItem.material(.cardboard),
            )
            ..setSlot(
              2,
              const WorkbenchItem.item(.sodisLakeWater),
            );

          expect(
            craft(),
            isTrue,
          );
          expect(
            deps.inventory.count(.wetCardboard),
            2,
          );
          expect(
            deps.inventory.count(.sodisBottle),
            1,
          );

          deps.workbench
            ..setSlot(
              0,
              const WorkbenchItem.material(.cardboard),
            )
            ..setSlot(
              1,
              const WorkbenchItem.item(.bottleLakeWater),
            );
          craft();

          expect(
            deps.inventory.count(.wetCardboard),
            3,
          );
          expect(
            deps.material.count(.plastic),
            1,
          );
          expect(
            deps.book.book.records,
            [BookRecord.wetCardboard],
          );
        },
      );

      test(
        'three cardboard or no water make nothing',
        () {
          final craft = diContainer.get<CraftUseCase>();
          for (var i = 0; i < 3; i++) {
            deps.workbench.setSlot(
              i,
              const WorkbenchItem.material(.cardboard),
            );
          }
          deps.workbench.setSlot(
            3,
            const WorkbenchItem.item(.cleanWater),
          );

          expect(
            craft(),
            isFalse,
          );

          deps.workbench
            ..reset()
            ..setSlot(
              0,
              const WorkbenchItem.material(.cardboard),
            )
            ..setSlot(
              1,
              const WorkbenchItem.item(.berries),
            );
          expect(
            craft(),
            isFalse,
          );
        },
      );
    },
  );

  group(
    'laying the farm',
    () {
      test(
        'wet cardboard and a tap on the house lay an empty farm',
        () async {
          deps.inventory.add(.wetCardboard);
          deps.inventory.add(.wetCardboard);
          deps.selection.selectSlot(0);

          expect(
            diContainer.get<PlaceStationUseCase>()(),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            deps.mushroom.farm,
            const MushroomFarm(
              isPlaced: true,
              isPlanted: false,
              seconds: 0,
            ),
          );
          expect(
            deps.inventory.count(.wetCardboard),
            0,
          );
          expect(
            messages.single.text,
            'You laid the wet cardboard Plant a wild mushroom on it',
          );
        },
      );

      test(
        'one wet cardboard is not enough',
        () async {
          deps.inventory.add(.wetCardboard);
          deps.selection.selectSlot(0);

          diContainer.get<PlaceStationUseCase>()();
          await pumpEventQueue();

          expect(
            deps.mushroom.farm.isPlaced,
            isFalse,
          );
          expect(
            messages.single.text,
            'You need 2 wet cardboard for a mushroom farm',
          );
        },
      );
    },
  );

  group(
    'UseMushroomFarmUseCase',
    () {
      test(
        'planting a wild mushroom completes the goal and writes the book record',
        () {
          plantFarm();

          expect(
            deps.mushroom.farm.isPlanted,
            isTrue,
          );
          expect(
            deps.inventory.count(.mushrooms),
            0,
          );
          expect(
            deps.construction.built,
            {Construction.mushroomFarm},
          );
          expect(
            deps.book.book.records,
            [BookRecord.mushroomFarm],
          );
        },
      );

      test(
        'a spoiled mushroom or another item cannot be planted',
        () async {
          deps.mushroom.place();
          selectMushroom(age: InventoryStack.spoilAge);
          useFarm();
          deps.selection.reset();
          deps.inventory.add(.berries);
          deps.selection.selectSlot(1);
          useFarm();
          await pumpEventQueue();

          expect(
            deps.mushroom.farm.isPlanted,
            isFalse,
          );
          expect(
            messages.map((message) => message.text),
            ['This food went bad', 'Plant a wild mushroom on the farm'],
          );
        },
      );

      test(
        'one mushroom a day, picked by a tap, then it grows again',
        () async {
          plantFarm();
          deps.selection.reset();
          useFarm();
          grow(MushroomFarm.growSeconds);
          await pumpEventQueue();

          expect(
            deps.mushroom.farm.isReady,
            isTrue,
          );
          useFarm();
          await pumpEventQueue();

          expect(
            deps.inventory.count(.mushrooms),
            1,
          );
          expect(
            deps.mushroom.farm.seconds,
            0,
          );
          expect(
            messages.map((message) => message.text).toList(),
            containsAllInOrder([
              'The mushroom is not ready yet',
              'A mushroom is ready on the farm',
              'You picked a mushroom +1 mushrooms',
            ]),
          );
        },
      );
    },
  );

  group(
    'levels and saves',
    () {
      test(
        'the planted farm carries over and starts growing again, a save keeps it',
        () {
          final startLevel = diContainer.get<StartLevelUseCase>();
          startLevel(.level2);
          plantFarm();
          grow(100);

          diContainer.get<SaveGameUseCase>()(.level2);
          final saved = deps.mushroom.farm;
          diContainer.get<CompleteLevelUseCase>()(.level2);
          startLevel(.level3);

          expect(
            deps.mushroom.farm,
            const MushroomFarm(
              isPlaced: true,
              isPlanted: true,
              seconds: 0,
            ),
          );

          deps.save.load(deps.save.saves.single);
          startLevel(.level2);
          expect(
            deps.mushroom.farm,
            saved,
          );
        },
      );
    },
  );

  test(
    'MushroomFarmRepositoryImpl grows only once planted and stops when ready',
    () {
      final repository = MushroomFarmRepositoryImpl()
        ..place()
        ..tick();
      expect(
        repository.farm.seconds,
        0,
      );

      repository.plant();
      for (var i = 0; i < GameDay.secondsPerDay + 5; i++) {
        repository.tick();
      }
      expect(
        repository.farm.seconds,
        MushroomFarm.growSeconds,
      );

      repository.collect();
      expect(
        repository.farm.seconds,
        0,
      );
    },
  );

  test(
    'MushroomBloc shows the farm and taps use it',
    () async {
      final bloc = MushroomBloc()..add(const MushroomStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();
      deps.mushroom.place();
      selectMushroom();

      bloc.add(const MushroomFarmTapped());
      await pumpEventQueue();

      expect(
        bloc.state.farm.isPlanted,
        isTrue,
      );
    },
  );
}
