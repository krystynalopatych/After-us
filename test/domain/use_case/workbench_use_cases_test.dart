import 'package:domain/construction/model/construction.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/station/model/workbench_recipe.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/workbench_slot_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late WorkbenchSlotUseCase workbenchSlot;
  late CraftUseCase craft;
  late List<FeedbackMessage> messages;

  const empty = <GameMaterial?>[null, null, null, null];

  setUp(() {
    deps = TestDependencies();
    workbenchSlot = WorkbenchSlotUseCase(
      feedbackRepository: deps.feedback,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
    );
    craft = CraftUseCase(
      constructionRepository: deps.construction,
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
    );
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

  group(
    'WorkbenchRecipe',
    () {
      test(
        'matches only the exact set of materials',
        () {
          expect(
            WorkbenchRecipe.fromMaterials({GameMaterial.metal: 1}),
            WorkbenchRecipe.cookingPot,
          );
          expect(
            WorkbenchRecipe.fromMaterials({GameMaterial.metal: 3}),
            WorkbenchRecipe.rocketStove,
          );
          expect(
            WorkbenchRecipe.fromMaterials({GameMaterial.metal: 2}),
            isNull,
          );
          expect(
            WorkbenchRecipe.fromMaterials({
              GameMaterial.plastic: 1,
              GameMaterial.cloth: 1,
              GameMaterial.sand: 1,
              GameMaterial.charcoal: 1,
            }),
            WorkbenchRecipe.waterFilter,
          );
          expect(
            WorkbenchRecipe.fromMaterials({
              GameMaterial.plastic: 1,
              GameMaterial.cloth: 1,
            }),
            isNull,
          );
        },
      );
    },
  );

  group(
    'WorkbenchSlotUseCase',
    () {
      test(
        'puts the selected material into the slot and keeps the selection',
        () {
          addMaterial(
            .metal,
            3,
          );
          deps.selection.selectMaterial(.metal);

          final slots = workbenchSlot(
            empty,
            2,
          );

          expect(
            slots,
            [null, null, GameMaterial.metal, null],
          );
          expect(
            deps.selection.selection.material,
            GameMaterial.metal,
          );
        },
      );

      test(
        'refuses a material when all of it is already on the workbench',
        () async {
          addMaterial(
            .metal,
            1,
          );
          deps.selection.selectMaterial(.metal);

          expect(
            workbenchSlot(
              const [GameMaterial.metal, null, null, null],
              1,
            ),
            [GameMaterial.metal, null, null, null],
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'You have no more metal',
          );
        },
      );

      test(
        'replaces the material in the same slot',
        () {
          addMaterial(
            .metal,
            1,
          );
          deps.selection.selectMaterial(.metal);

          expect(
            workbenchSlot(
              const [GameMaterial.metal, null, null, null],
              0,
            ),
            [GameMaterial.metal, null, null, null],
          );
        },
      );

      test(
        'clears a slot when nothing is selected',
        () {
          expect(
            workbenchSlot(
              const [GameMaterial.metal, null, null, null],
              0,
            ),
            empty,
          );
        },
      );

      test(
        'refuses inventory items',
        () async {
          deps.inventory.add(.berries);
          deps.selection.selectSlot(0);

          expect(
            workbenchSlot(
              empty,
              0,
            ),
            empty,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            "You can't use this at the workbench",
          );
        },
      );
    },
  );

  group(
    'CraftUseCase',
    () {
      test(
        'crafts a SODIS bottle from one plastic',
        () async {
          addMaterial(
            .plastic,
            2,
          );
          deps.selection.selectMaterial(.plastic);

          expect(
            craft(const [null, GameMaterial.plastic, null, null]),
            isTrue,
          );
          expect(
            deps.inventory.count(.sodisBottle),
            1,
          );
          expect(
            deps.material.count(.plastic),
            1,
          );
          expect(
            deps.selection.selection.material,
            isNull,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'You crafted a SODIS bottle',
          );
        },
      );

      test(
        'building the water filter completes the goal and adds the filter',
        () {
          for (final material in [GameMaterial.plastic, GameMaterial.cloth, GameMaterial.sand, GameMaterial.charcoal]) {
            deps.material.add(material);
          }

          expect(
            craft(const [GameMaterial.plastic, GameMaterial.cloth, GameMaterial.sand, GameMaterial.charcoal]),
            isTrue,
          );
          expect(
            deps.construction.built,
            {Construction.waterFilter},
          );
          expect(
            deps.inventory.count(.waterFilter),
            1,
          );
          expect(
            deps.material.stocks,
            isEmpty,
          );
        },
      );

      test(
        'building the rocket stove takes three metal',
        () {
          addMaterial(
            .metal,
            3,
          );

          expect(
            craft(const [GameMaterial.metal, GameMaterial.metal, GameMaterial.metal, null]),
            isTrue,
          );
          expect(
            deps.construction.built,
            {Construction.rocketStove},
          );
          expect(
            deps.inventory.count(.rocketStove),
            1,
          );
          expect(
            deps.inventory.count(.cookingPot),
            0,
          );
        },
      );

      test(
        'refuses a set that makes nothing',
        () async {
          addMaterial(
            .metal,
            2,
          );

          expect(
            craft(const [GameMaterial.metal, GameMaterial.metal, null, null]),
            isFalse,
          );
          expect(
            deps.material.count(.metal),
            2,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'Nothing can be crafted from this',
          );
        },
      );

      test(
        'refuses when the inventory is full',
        () async {
          for (var i = 0; i < 60; i++) {
            deps.inventory.add(.berries);
          }
          addMaterial(
            .metal,
            1,
          );

          expect(
            craft(const [GameMaterial.metal, null, null, null]),
            isFalse,
          );
          expect(
            deps.material.count(.metal),
            1,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'Your inventory is full',
          );
        },
      );
    },
  );
}
