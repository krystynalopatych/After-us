import 'package:domain/book/model/book_record.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/fridge/model/fridge.dart';
import 'package:domain/fridge/use_case/fridge_cooling_use_case.dart';
import 'package:domain/fridge/use_case/fridge_slot_use_case.dart';
import 'package:domain/fridge/use_case/water_fridge_use_case.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/progress/use_case/complete_level_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/station/model/campfire_recipe.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/use_case/campfire_recipe_use_case.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/place_station_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late List<FeedbackMessage> messages;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    messages = [];
    final subscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(subscription.cancel);
  });

  void select(InventoryItem item) {
    deps.inventory.add(item);
    deps.selection.selectSlot(deps.inventory.stacks.indexWhere((stack) => stack.item == item));
  }

  void addMaterial(
    GameMaterial material,
    int count,
  ) {
    for (var i = 0; i < count; i++) {
      deps.material.add(material);
    }
  }

  group(
    'clay pot',
    () {
      test(
        'clay is fired on the campfire without a cooking pot',
        () async {
          addMaterial(
            .clay,
            2,
          );
          deps.selection.selectMaterial(.clay);

          final recipe = diContainer.get<CampfireRecipeUseCase>()(.campfire);

          expect(
            recipe,
            CampfireRecipe.fireClayPot,
          );
        },
      );

      test(
        'two clay and one wood make one clay pot on the campfire or the rocket stove',
        () async {
          final cook = diContainer.get<CookOnCampfireUseCase>();
          addMaterial(
            .clay,
            4,
          );
          addMaterial(
            .wood,
            2,
          );

          for (final station in [Station.campfire, Station.rocketStove]) {
            deps.material.remove(
              .clay,
              2,
            );
            deps.fire.load(.fireClayPot);
            expect(
              cook(
                .fireClayPot,
                .wood,
                station,
              ),
              isTrue,
            );
          }
          await pumpEventQueue();

          expect(
            deps.material.count(.clayPot),
            2,
          );
          expect(
            deps.material.count(.clay),
            0,
          );
          expect(
            deps.material.count(.wood),
            0,
          );
          expect(
            messages.first.text,
            'You fired a clay pot +1 clay pot',
          );
        },
      );

      test(
        'one clay is not enough and the campfire says so',
        () async {
          addMaterial(
            .clay,
            1,
          );
          deps.selection.selectMaterial(.clay);

          expect(
            diContainer.get<CampfireRecipeUseCase>()(.campfire),
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'You need 2 clay for this',
          );
        },
      );
    },
  );

  group(
    'clay fridge',
    () {
      test(
        'two clay pots and two sand make a fridge at the workbench',
        () {
          for (final (index, material) in [
            GameMaterial.clayPot,
            GameMaterial.clayPot,
            GameMaterial.sand,
            GameMaterial.sand,
          ].indexed) {
            deps.workbench.setSlot(
              index,
              WorkbenchItem.material(material),
            );
          }

          final isCrafted = diContainer.get<CraftUseCase>()();

          expect(
            isCrafted,
            isTrue,
          );
          expect(
            deps.inventory.count(.clayFridge),
            1,
          );
          expect(
            deps.construction.built,
            {Construction.clayFridge},
          );
          expect(
            deps.book.book.records,
            contains(BookRecord.clayFridge),
          );
        },
      );

      test(
        'the fridge from the inventory is set up at the house',
        () async {
          select(.clayFridge);

          expect(
            diContainer.get<PlaceStationUseCase>()(),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            deps.station.built,
            {Station.clayFridge},
          );
          expect(
            deps.inventory.count(.clayFridge),
            0,
          );
          expect(
            messages.single.text,
            'You set up the clay fridge Water it with lake water every day',
          );
        },
      );
    },
  );

  group(
    'FridgeSlotUseCase',
    () {
      test(
        'puts the selected food into the tapped slot',
        () {
          select(.berries);
          deps.inventory.add(.berries);

          diContainer.get<FridgeSlotUseCase>()(1);

          expect(
            deps.fridge.fridge.slots[1],
            const InventoryStack(
              item: .berries,
              count: 1,
            ),
          );
          expect(
            deps.inventory.count(.berries),
            1,
          );
          expect(
            deps.selection.selection.slot,
            isNotNull,
          );
        },
      );

      test(
        'clears the selection when the last portion goes into the fridge',
        () {
          select(.mushrooms);

          diContainer.get<FridgeSlotUseCase>()(0);

          expect(
            deps.selection.selection.slot,
            isNull,
          );
        },
      );

      test(
        'keeps drinks and tools out',
        () async {
          final slot = diContainer.get<FridgeSlotUseCase>();
          select(.cleanWater);
          slot(0);
          deps.selection.reset();
          select(.cookingPot);
          slot(0);
          await pumpEventQueue();

          expect(
            deps.fridge.fridge,
            const Fridge.empty(),
          );
          expect(
            messages.map((message) => message.text),
            ['Only food goes into the fridge', 'Only food goes into the fridge'],
          );
        },
      );

      test(
        'tapping a slot without a selection takes one portion back',
        () {
          deps.fridge
            ..put(
              3,
              .algae,
            )
            ..put(
              3,
              .algae,
            );

          diContainer.get<FridgeSlotUseCase>()(3);

          expect(
            deps.inventory.count(.algae),
            1,
          );
          expect(
            deps.fridge.fridge.slots[3]?.count,
            1,
          );
        },
      );

      test(
        'keeps the food in the fridge when the inventory is full',
        () async {
          while (deps.inventory.add(.cleanWater)) {}
          deps.fridge.put(
            0,
            .mushrooms,
          );

          diContainer.get<FridgeSlotUseCase>()(0);
          await pumpEventQueue();

          expect(
            deps.fridge.fridge.slots.first?.item,
            InventoryItem.mushrooms,
          );
          expect(
            messages.single.text,
            'Your inventory is full',
          );
        },
      );
    },
  );

  group(
    'WaterFridgeUseCase',
    () {
      test(
        'lake water in a plastic bottle waters the fridge for today and gives the plastic back',
        () async {
          select(.bottleLakeWater);

          expect(
            diContainer.get<WaterFridgeUseCase>()(),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            diContainer.get<FridgeCoolingUseCase>().isCooling,
            isTrue,
          );
          expect(
            deps.inventory.count(.bottleLakeWater),
            0,
          );
          expect(
            deps.material.count(.plastic),
            1,
          );
          expect(
            messages.single.text,
            'You watered the fridge Food stays fresh today +1 plastic',
          );
        },
      );

      test(
        'lake water in a SODIS bottle leaves the empty bottle',
        () {
          select(.sodisLakeWater);

          diContainer.get<WaterFridgeUseCase>()();

          expect(
            deps.inventory.count(.sodisBottle),
            1,
          );
        },
      );

      test(
        'a second watering on the same day keeps the water',
        () async {
          deps.fridge.water(1);
          select(.bottleLakeWater);

          diContainer.get<WaterFridgeUseCase>()();
          await pumpEventQueue();

          expect(
            deps.inventory.count(.bottleLakeWater),
            1,
          );
          expect(
            messages.single.text,
            'The fridge is already watered today',
          );
        },
      );

      test(
        'clean water is not wasted on the fridge',
        () async {
          select(.cleanWater);

          expect(
            diContainer.get<WaterFridgeUseCase>()(),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            deps.inventory.count(.cleanWater),
            1,
          );
          expect(
            messages.single.text,
            'Use lake water for the fridge',
          );
        },
      );

      test(
        'food or no selection opens the fridge instead',
        () {
          final water = diContainer.get<WaterFridgeUseCase>();
          expect(
            water(),
            isFalse,
          );

          select(.berries);
          expect(
            water(),
            isFalse,
          );
        },
      );

      test(
        'watering keeps the fridge cold through the night until 08:00 of the next day',
        () {
          final cooling = diContainer.get<FridgeCoolingUseCase>();
          deps.fridge.water(1);
          deps.day.setDay(
            const GameDay(
              number: 2,
              seconds: 0,
              nightSeconds: 5,
            ),
          );
          expect(
            cooling.isCooling,
            isTrue,
          );

          deps.day.setDay(
            const GameDay(
              number: 2,
              seconds: Fridge.morningGraceSeconds - 1,
            ),
          );
          expect(
            cooling.isCooling,
            isTrue,
          );

          deps.day.setDay(
            const GameDay(
              number: 2,
              seconds: Fridge.morningGraceSeconds,
            ),
          );
          expect(
            cooling.isCooling,
            isFalse,
          );
        },
      );

      test(
        'during the morning grace the fridge can be watered for the new day',
        () {
          deps.fridge.water(1);
          deps.day.setDay(
            const GameDay(
              number: 2,
              seconds: 10,
            ),
          );
          select(.bottleLakeWater);

          diContainer.get<WaterFridgeUseCase>()();

          expect(
            deps.fridge.fridge.wateredDay,
            2,
          );
        },
      );
    },
  );

  group(
    'level start, saves and carry-over',
    () {
      test(
        'the food in the fridge carries over to the next level but the watering does not',
        () {
          final startLevel = diContainer.get<StartLevelUseCase>();
          startLevel(.level2);
          deps.fridge
            ..put(
              0,
              .berries,
            )
            ..water(1);

          diContainer.get<CompleteLevelUseCase>()(.level2);
          startLevel(.level3);

          expect(
            deps.fridge.fridge.slots.first?.item,
            InventoryItem.berries,
          );
          expect(
            deps.fridge.fridge.wateredDay,
            isNull,
          );
        },
      );

      test(
        'a save keeps the fridge and loading restores it',
        () {
          final startLevel = diContainer.get<StartLevelUseCase>();
          startLevel(.level2);
          deps.fridge
            ..put(
              2,
              .mushrooms,
            )
            ..water(1);
          final saved = deps.fridge.fridge;

          diContainer.get<SaveGameUseCase>()(.level2);
          deps.fridge.reset();
          deps.save.load(deps.save.saves.single);
          startLevel(.level2);

          expect(
            deps.fridge.fridge,
            saved,
          );
        },
      );

      test(
        'level 1 starts with an empty fridge',
        () {
          deps.fridge.put(
            0,
            .berries,
          );

          diContainer.get<StartLevelUseCase>()(.level1);

          expect(
            deps.fridge.fridge,
            const Fridge.empty(),
          );
        },
      );
    },
  );
}
