import 'package:data/garden/repository/garden_bed_repository_impl.dart';
import 'package:domain/book/model/book_record.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/garden/model/garden_bed.dart';
import 'package:domain/garden/use_case/use_garden_bed_use_case.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/progress/use_case/complete_level_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/place_station_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';
import 'package:presentation/feature/garden/bloc/garden_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late List<FeedbackMessage> messages;
  late UseGardenBedUseCase useBed;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    useBed = diContainer.get();
    messages = [];
    final subscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(subscription.cancel);
  });

  void select(InventoryItem item) {
    deps.inventory.add(item);
    deps.selection.selectSlot(deps.inventory.stacks.indexWhere((stack) => stack.item == item));
  }

  void plantBed() {
    deps.garden.place();
    deps.material
      ..add(.seeds)
      ..add(.seeds);
    deps.selection.selectMaterial(.seeds);
    useBed();
    useBed();
  }

  void grow(int seconds) {
    final passSecond = diContainer.get<PassSecondUseCase>();
    for (var i = 0; i < seconds; i++) {
      passSecond(.level2);
    }
  }

  group(
    'GardenBedRepositoryImpl',
    () {
      test(
        'grows only once planted and stops when ready, harvest restarts it',
        () {
          final repository = GardenBedRepositoryImpl()
            ..place()
            ..tick();
          expect(
            repository.bed.seconds,
            0,
          );

          repository
            ..plant()
            ..plant()
            ..fertilize();
          for (var i = 0; i < GardenBed.growSeconds + 5; i++) {
            repository.tick();
          }
          expect(
            repository.bed.seconds,
            GardenBed.growSeconds,
          );
          expect(
            repository.bed.harvestCount,
            3,
          );

          repository.harvest();
          expect(
            repository.bed,
            const GardenBed(
              isPlaced: true,
              seeds: 2,
              hasGreenhouse: false,
              isFertilized: false,
              seconds: 0,
            ),
          );
        },
      );
    },
  );

  test(
    'the bed looks empty for the first half of growing, then shows sprouts, then potatoes',
    () {
      const planted = GardenBed(
        isPlaced: true,
        seeds: 2,
        hasGreenhouse: true,
        isFertilized: false,
        seconds: 0,
      );

      expect(
        planted.hasSprouts,
        isFalse,
      );
      expect(
        planted.copyWith(seconds: GardenBed.greenhouseGrowSeconds ~/ 2).hasSprouts,
        isTrue,
      );
      expect(
        planted.copyWith(seconds: GardenBed.greenhouseGrowSeconds).isReady,
        isTrue,
      );
      expect(
        const GardenBed.none().hasSprouts,
        isFalse,
      );
    },
  );

  group(
    'crafting and setting up',
    () {
      test(
        'four compost make a garden bed and two plastic a greenhouse, both with book records',
        () {
          final craft = diContainer.get<CraftUseCase>();
          for (var i = 0; i < 4; i++) {
            deps.workbench.setSlot(
              i,
              const WorkbenchItem.material(.compost),
            );
          }
          expect(
            craft(),
            isTrue,
          );
          deps.workbench
            ..setSlot(
              0,
              const WorkbenchItem.material(.plastic),
            )
            ..setSlot(
              1,
              const WorkbenchItem.material(.plastic),
            );
          expect(
            craft(),
            isTrue,
          );

          expect(
            deps.inventory.count(.gardenBed),
            1,
          );
          expect(
            deps.inventory.count(.greenhouse),
            1,
          );
          expect(
            deps.book.book.records,
            [BookRecord.gardenBed, BookRecord.greenhouse],
          );
        },
      );

      test(
        'the garden bed from the inventory is set up at the house',
        () async {
          select(.gardenBed);

          expect(
            diContainer.get<PlaceStationUseCase>()(),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            deps.garden.bed.isPlaced,
            isTrue,
          );
          expect(
            deps.inventory.count(.gardenBed),
            0,
          );
          expect(
            messages.single.text,
            'You set up the garden bed Plant 2 seeds in it',
          );
        },
      );
    },
  );

  group(
    'UseGardenBedUseCase',
    () {
      test(
        'two seeds one by one plant the bed',
        () async {
          plantBed();
          await pumpEventQueue();

          expect(
            deps.garden.bed.isPlanted,
            isTrue,
          );
          expect(
            deps.material.count(GameMaterial.seeds),
            0,
          );
          expect(
            messages.map((message) => message.text),
            ['You planted a seed 1/2', 'The seeds are planted potatoes grow in a day'],
          );
        },
      );

      test(
        'the goal is done once the planted bed has its greenhouse',
        () {
          plantBed();
          expect(
            deps.construction.built,
            isEmpty,
          );

          select(.greenhouse);
          useBed();

          expect(
            deps.garden.bed.hasGreenhouse,
            isTrue,
          );
          expect(
            deps.inventory.count(.greenhouse),
            0,
          );
          expect(
            deps.construction.built,
            {Construction.gardenBed},
          );
        },
      );

      test(
        'grows in a day, in half a day with the greenhouse, and says when it is ready',
        () async {
          plantBed();
          grow(GardenBed.growSeconds - 1);
          expect(
            deps.garden.bed.isReady,
            isFalse,
          );
          grow(1);
          expect(
            deps.garden.bed.isReady,
            isTrue,
          );
          await pumpEventQueue();
          expect(
            messages.last.text,
            'Your potatoes are ready',
          );

          deps.selection.reset();
          useBed();
          select(.greenhouse);
          useBed();
          grow(GardenBed.greenhouseGrowSeconds + GameDay.nightLength);
          expect(
            deps.garden.bed.isReady,
            isTrue,
          );
        },
      );

      test(
        'digging up the potatoes gives two, or three after algae',
        () {
          plantBed();
          select(.algae);
          useBed();
          expect(
            deps.inventory.count(.algae),
            0,
          );
          grow(GardenBed.growSeconds);

          deps.selection.reset();
          useBed();
          expect(
            deps.inventory.count(.potato),
            3,
          );

          grow(GardenBed.growSeconds + GameDay.nightLength);
          useBed();
          expect(
            deps.inventory.count(.potato),
            5,
          );
        },
      );

      test(
        'an unready bed, a full inventory or a wrong item keep everything as it is',
        () async {
          plantBed();
          deps.selection.reset();
          useBed();
          select(.cookingPot);
          useBed();
          grow(GardenBed.growSeconds);
          deps.selection.reset();
          while (deps.inventory.add(.cleanWater)) {}
          useBed();
          await pumpEventQueue();

          expect(
            deps.garden.bed.isReady,
            isTrue,
          );
          expect(
            messages.map((message) => message.text).toList(),
            containsAllInOrder([
              'The potatoes are not ready yet',
              "You can't use this on the garden bed",
              'Your potatoes are ready',
              'Your inventory is full',
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
        'the bed carries over with its seeds and greenhouse but starts growing again',
        () {
          final startLevel = diContainer.get<StartLevelUseCase>();
          startLevel(.level2);
          plantBed();
          deps.garden.addGreenhouse();
          grow(100);

          diContainer.get<CompleteLevelUseCase>()(.level2);
          startLevel(.level3);

          expect(
            deps.garden.bed,
            const GardenBed(
              isPlaced: true,
              seeds: 2,
              hasGreenhouse: true,
              isFertilized: false,
              seconds: 0,
            ),
          );
        },
      );

      test(
        'a save keeps the bed and level 1 starts without one',
        () {
          final startLevel = diContainer.get<StartLevelUseCase>();
          startLevel(.level2);
          plantBed();
          final saved = deps.garden.bed;

          diContainer.get<SaveGameUseCase>()(.level2);
          deps.garden.reset();
          deps.save.load(deps.save.saves.single);
          startLevel(.level2);
          expect(
            deps.garden.bed,
            saved,
          );

          startLevel(.level1);
          expect(
            deps.garden.bed,
            const GardenBed.none(),
          );
        },
      );
    },
  );

  test(
    'GardenBloc shows the bed and taps use it',
    () async {
      final bloc = GardenBloc()..add(const GardenStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();
      deps.garden.place();
      deps.material.add(.seeds);
      deps.selection.selectMaterial(.seeds);

      bloc.add(const GardenBedTapped());
      await pumpEventQueue();

      expect(
        bloc.state.bed.seeds,
        1,
      );
    },
  );
}
