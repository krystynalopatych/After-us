import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/fridge/use_case/fridge_slot_use_case.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/inventory/use_case/spoil_food_use_case.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:domain/progress/model/level_carry_over.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/station/use_case/campfire_recipe_use_case.dart';
import 'package:domain/station/use_case/workbench_slot_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late List<FeedbackMessage> messages;
  late SpoilFoodUseCase spoil;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    spoil = diContainer.get();
    messages = [];
    final subscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(subscription.cancel);
  });

  void passDay() {
    for (var i = 0; i < InventoryStack.spoilAge; i++) {
      spoil(.level2);
    }
  }

  group(
    'SpoilFoodUseCase',
    () {
      test(
        'food in the inventory goes bad after one game day and says so once',
        () async {
          deps.inventory
            ..add(.berries)
            ..add(.cleanWater)
            ..add(.cookingPot);

          for (var i = 0; i < InventoryStack.spoilAge - 1; i++) {
            spoil(.level2);
          }
          expect(
            deps.inventory.stacks.first.isSpoiled,
            isFalse,
          );

          spoil(.level2);
          spoil(.level2);
          await pumpEventQueue();

          expect(
            deps.inventory.stacks.first.isSpoiled,
            isTrue,
          );
          expect(
            deps.inventory.stacks.skip(1).map((stack) => stack.age),
            [0, 0],
          );
          expect(
            messages.single,
            const FeedbackMessage(
              text: 'Your berries went bad',
              mood: .sad,
            ),
          );
        },
      );

      test(
        'nothing spoils on level 1, while the map is open or after the level ended',
        () {
          deps.inventory.add(.berries);

          spoil(.level1);
          deps.clock.setPaused(true);
          spoil(.level2);
          deps.clock.setPaused(false);
          deps.day.setOutcome(.won);
          spoil(.level2);

          expect(
            deps.inventory.stacks.single.age,
            0,
          );
        },
      );

      test(
        'a watered fridge keeps food fresh, an unwatered one does not',
        () {
          deps.fridge
            ..put(
              0,
              .berries,
            )
            ..water(1);

          passDay();
          expect(
            deps.fridge.fridge.slots.first?.age,
            0,
          );

          deps.fridge.water(0);
          passDay();
          expect(
            deps.fridge.fridge.slots.first?.isSpoiled,
            isTrue,
          );
        },
      );
    },
  );

  group(
    'stacks',
    () {
      test(
        'fresh food joins a stack of the same food and the stack keeps the oldest timer',
        () {
          deps.inventory.add(
            .berries,
            age: 100,
          );
          deps.inventory.add(.berries);

          expect(
            deps.inventory.stacks.single,
            const InventoryStack(
              item: .berries,
              count: 2,
              age: 100,
            ),
          );
        },
      );

      test(
        'spoiled and fresh food never share a stack',
        () {
          deps.inventory.add(
            .berries,
            age: InventoryStack.spoilAge,
          );
          deps.inventory.add(.berries);

          expect(
            deps.inventory.stacks.map((stack) => stack.isSpoiled),
            [true, false],
          );
        },
      );

      test(
        'food keeps its timer on the way into the fridge and back',
        () {
          deps.inventory.add(
            .algae,
            age: 250,
          );
          deps.selection.selectSlot(0);
          final slot = diContainer.get<FridgeSlotUseCase>();

          slot(2);
          expect(
            deps.fridge.fridge.slots[2]?.age,
            250,
          );

          slot(2);
          expect(
            deps.inventory.stacks.single.age,
            250,
          );
        },
      );
    },
  );

  group(
    'eating',
    () {
      test(
        'spoiled food fills half and costs 10 health',
        () async {
          deps.player.setStats(
            const PlayerStats(
              health: 50,
              hunger: 50,
              thirst: 50,
            ),
          );
          deps.inventory
            ..add(.berries)
            ..add(
              .berries,
              age: InventoryStack.spoilAge,
            );

          expect(
            diContainer.get<ConsumeUseCase>()(1),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            deps.player.stats.hunger,
            55,
          );
          expect(
            deps.player.stats.health,
            40,
          );
          expect(
            deps.inventory.stacks.single.isSpoiled,
            isFalse,
          );
          expect(
            messages.single.text,
            'You ate spoiled berries +5 hunger +1.5 thirst −10 health',
          );
        },
      );
    },
  );

  group(
    'stations',
    () {
      test(
        'spoiled food cannot be cooked or put on the workbench',
        () async {
          deps.inventory
            ..add(.cookingPot)
            ..add(
              .cattailRoot,
              age: InventoryStack.spoilAge,
            );
          deps.selection.selectSlot(1);

          expect(
            diContainer.get<CampfireRecipeUseCase>()(.campfire),
            isNull,
          );
          deps.selection.selectSlot(1);
          diContainer.get<WorkbenchSlotUseCase>()(0);
          await pumpEventQueue();

          expect(
            deps.inventory.count(.cattailRoot),
            1,
          );
          expect(
            deps.workbench.slots.first,
            isNull,
          );
          expect(
            messages.map((message) => message.text),
            ['This food went bad', 'This food went bad'],
          );
        },
      );
    },
  );

  group(
    'level start',
    () {
      test(
        'food carried from the last level starts fresh, spoiled food stays spoiled',
        () {
          deps.carryOver.keep(
            .level2,
            const LevelCarryOver(
              inventory: [
                InventoryStack(
                  item: .berries,
                  count: 2,
                  age: 400,
                ),
                InventoryStack(
                  item: .algae,
                  count: 1,
                  age: InventoryStack.spoilAge,
                ),
              ],
              constructions: {},
              stations: {},
            ),
          );

          diContainer.get<StartLevelUseCase>()(.level2);

          expect(
            deps.inventory.stacks.map((stack) => stack.age),
            [0, InventoryStack.spoilAge],
          );
          expect(
            deps.inventory.count(InventoryItem.berries),
            2,
          );
        },
      );
    },
  );
}
