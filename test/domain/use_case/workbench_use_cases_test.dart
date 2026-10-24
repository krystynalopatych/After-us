import 'package:domain/book/model/book_record.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/station/model/workbench_item.dart';
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

  const empty = <WorkbenchItem?>[null, null, null, null];

  setUp(() {
    deps = TestDependencies();
    workbenchSlot = WorkbenchSlotUseCase(
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
    );
    craft = CraftUseCase(
      bookRepository: deps.book,
      constructionRepository: deps.construction,
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
      soundRepository: deps.sound,
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
            [null, null, WorkbenchItem.material(.metal), null],
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
              const [WorkbenchItem.material(.metal), null, null, null],
              1,
            ),
            [WorkbenchItem.material(.metal), null, null, null],
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
              const [WorkbenchItem.material(.metal), null, null, null],
              0,
            ),
            [WorkbenchItem.material(.metal), null, null, null],
          );
        },
      );

      test(
        'clears a slot when nothing is selected',
        () {
          expect(
            workbenchSlot(
              const [WorkbenchItem.material(.metal), null, null, null],
              0,
            ),
            empty,
          );
        },
      );

      test(
        'puts the selected inventory item into the slot',
        () {
          deps.inventory.add(.algae);
          deps.selection.selectSlot(0);

          expect(
            workbenchSlot(
              empty,
              1,
            ),
            [null, const WorkbenchItem.item(.algae), null, null],
          );
          expect(
            workbenchSlot(
              const [null, WorkbenchItem.item(.algae), null, null],
              2,
            ),
            [null, const WorkbenchItem.item(.algae), null, null],
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
            craft(const [null, WorkbenchItem.material(.plastic), null, null]),
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
            craft(const [
              WorkbenchItem.material(.plastic),
              WorkbenchItem.material(.cloth),
              WorkbenchItem.material(.sand),
              WorkbenchItem.material(.charcoal),
            ]),
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
            craft(const [
              WorkbenchItem.material(.metal),
              WorkbenchItem.material(.metal),
              WorkbenchItem.material(.metal),
              null,
            ]),
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
        'soaks two algae in clean water and gives the SODIS bottle back',
        () async {
          deps.inventory
            ..add(.algae)
            ..add(.algae)
            ..add(.sodisCleanWater);

          expect(
            craft(const [
              WorkbenchItem.item(.algae),
              WorkbenchItem.item(.algae),
              WorkbenchItem.item(.sodisCleanWater),
              null,
            ]),
            isTrue,
          );
          expect(
            deps.inventory.count(.algaeSoaked),
            2,
          );
          expect(
            deps.inventory.count(.algae),
            0,
          );
          expect(
            deps.inventory.count(.sodisBottle),
            1,
          );
          await pumpEventQueue();
          expect(
            messages.single.text,
            'You soaked the algae +2 soaked algae',
          );
        },
      );

      test(
        'soaks one alga in boiled water',
        () {
          deps.inventory
            ..add(.algae)
            ..add(.cleanWater);

          expect(
            craft(const [WorkbenchItem.item(.cleanWater), WorkbenchItem.item(.algae), null, null]),
            isTrue,
          );
          expect(
            deps.inventory.stacks.map((stack) => stack.item),
            [InventoryItem.algaeSoaked],
          );
        },
      );

      test(
        'filtered water in a plastic bottle gives the plastic back',
        () {
          deps.inventory
            ..add(.algae)
            ..add(.bottleFilteredWater);

          expect(
            craft(const [WorkbenchItem.item(.algae), WorkbenchItem.item(.bottleFilteredWater), null, null]),
            isTrue,
          );
          expect(
            deps.material.count(.plastic),
            1,
          );
        },
      );

      test(
        'algae do not soak in dirty water or with too many algae',
        () {
          deps.inventory
            ..add(.algae)
            ..add(.algae)
            ..add(.algae)
            ..add(.sodisLakeWater)
            ..add(.cleanWater);

          expect(
            craft(const [WorkbenchItem.item(.algae), WorkbenchItem.item(.sodisLakeWater), null, null]),
            isFalse,
          );
          expect(
            craft(const [
              WorkbenchItem.item(.algae),
              WorkbenchItem.item(.algae),
              WorkbenchItem.item(.algae),
              WorkbenchItem.item(.cleanWater),
            ]),
            isFalse,
          );
          expect(
            deps.inventory.count(.algae),
            3,
          );
        },
      );

      test(
        'every first craft writes a book record, repeats do not',
        () {
          deps.material
            ..add(.metal)
            ..add(.metal);
          deps.inventory
            ..add(.algae)
            ..add(.cleanWater);

          craft(const [WorkbenchItem.material(.metal), null, null, null]);
          craft(const [WorkbenchItem.material(.metal), null, null, null]);
          craft(const [WorkbenchItem.item(.algae), WorkbenchItem.item(.cleanWater), null, null]);

          expect(
            deps.book.book.records,
            [BookRecord.cookingPot, BookRecord.soakedAlgae],
          );
          expect(
            deps.book.book.hasNewRecord,
            isTrue,
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
            craft(const [WorkbenchItem.material(.metal), WorkbenchItem.material(.metal), null, null]),
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
            craft(const [WorkbenchItem.material(.metal), null, null, null]),
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
