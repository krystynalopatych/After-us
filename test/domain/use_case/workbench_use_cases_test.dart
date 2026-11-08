import 'package:domain/book/model/book_record.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/model/workbench_recipe.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/return_station_items_use_case.dart';
import 'package:domain/station/use_case/workbench_slot_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late WorkbenchSlotUseCase workbenchSlot;
  late CraftUseCase craft;
  late ReturnStationItemsUseCase returnItems;
  late List<FeedbackMessage> messages;

  const empty = <WorkbenchItem?>[null, null, null, null];

  setUp(() {
    deps = TestDependencies();
    workbenchSlot = WorkbenchSlotUseCase(
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
      workbenchRepository: deps.workbench,
    );
    craft = CraftUseCase(
      bookRepository: deps.book,
      constructionRepository: deps.construction,
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
      soundRepository: deps.sound,
      workbenchRepository: deps.workbench,
    );
    returnItems = ReturnStationItemsUseCase(
      fireRepository: deps.fire,
      inventoryRepository: deps.inventory,
      materialRepository: deps.material,
      workbenchRepository: deps.workbench,
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

  void onBench(List<WorkbenchItem?> slots) {
    for (final (index, slot) in slots.indexed) {
      deps.workbench.setSlot(
        index,
        slot,
      );
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
        'takes the selected material from the counter into the slot and keeps the selection',
        () {
          addMaterial(
            .metal,
            3,
          );
          deps.selection.selectMaterial(.metal);

          workbenchSlot(2);

          expect(
            deps.workbench.slots,
            [null, null, WorkbenchItem.material(.metal), null],
          );
          expect(
            deps.material.count(.metal),
            2,
          );
          expect(
            deps.selection.selection.material,
            GameMaterial.metal,
          );
        },
      );

      test(
        'clears the selection when the last one goes onto the workbench',
        () {
          addMaterial(
            .metal,
            1,
          );
          deps.selection.selectMaterial(.metal);

          workbenchSlot(0);

          expect(
            deps.material.count(.metal),
            0,
          );
          expect(
            deps.selection.selection.material,
            isNull,
          );
        },
      );

      test(
        'refuses a material the counter has no more of',
        () async {
          deps.selection.selectMaterial(.metal);

          workbenchSlot(1);
          await pumpEventQueue();

          expect(
            deps.workbench.slots,
            empty,
          );
          expect(
            messages.single.text,
            'You have no more metal',
          );
        },
      );

      test(
        'a new material in a used slot sends the old one back',
        () {
          addMaterial(
            .metal,
            1,
          );
          addMaterial(
            .plastic,
            1,
          );
          deps.selection.selectMaterial(.metal);
          workbenchSlot(0);
          deps.selection.selectMaterial(.plastic);

          workbenchSlot(0);

          expect(
            deps.workbench.slots.first,
            const WorkbenchItem.material(.plastic),
          );
          expect(
            deps.material.count(.metal),
            1,
          );
          expect(
            deps.material.count(.plastic),
            0,
          );
        },
      );

      test(
        'tapping a slot with nothing selected gives its material back',
        () {
          onBench(const [WorkbenchItem.material(.metal), null, null, null]);

          workbenchSlot(0);

          expect(
            deps.workbench.slots,
            empty,
          );
          expect(
            deps.material.count(.metal),
            1,
          );
        },
      );

      test(
        'takes the selected inventory item into the slot',
        () {
          deps.inventory
            ..add(.algae)
            ..add(.algae);
          deps.selection.selectSlot(0);

          workbenchSlot(1);

          expect(
            deps.workbench.slots,
            [null, const WorkbenchItem.item(.algae), null, null],
          );
          expect(
            deps.inventory.count(.algae),
            1,
          );
        },
      );
    },
  );

  group(
    'ReturnStationItemsUseCase',
    () {
      test(
        'closing the workbench gives everything on it back',
        () {
          onBench(const [
            WorkbenchItem.material(.metal),
            WorkbenchItem.material(.metal),
            WorkbenchItem.item(.algae),
            null,
          ]);

          returnItems();

          expect(
            deps.workbench.slots,
            empty,
          );
          expect(
            deps.material.count(.metal),
            2,
          );
          expect(
            deps.inventory.count(.algae),
            1,
          );
        },
      );
    },
  );

  group(
    'CraftUseCase',
    () {
      test(
        'crafts a SODIS bottle from the plastic on the workbench',
        () async {
          addMaterial(
            .plastic,
            1,
          );
          deps.selection.selectMaterial(.plastic);
          onBench(const [null, WorkbenchItem.material(.plastic), null, null]);

          expect(
            craft(),
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
            deps.workbench.slots,
            empty,
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
        'a crafted set is not given back when the workbench closes',
        () {
          onBench(const [WorkbenchItem.material(.metal), null, null, null]);

          craft();
          returnItems();

          expect(
            deps.material.count(.metal),
            0,
          );
          expect(
            deps.inventory.count(.cookingPot),
            1,
          );
        },
      );

      test(
        'building the water filter completes the goal and adds the filter',
        () {
          onBench(const [
            WorkbenchItem.material(.plastic),
            WorkbenchItem.material(.cloth),
            WorkbenchItem.material(.sand),
            WorkbenchItem.material(.charcoal),
          ]);

          expect(
            craft(),
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
        },
      );

      test(
        'building the rocket stove takes three metal',
        () {
          onBench(const [
            WorkbenchItem.material(.metal),
            WorkbenchItem.material(.metal),
            WorkbenchItem.material(.metal),
            null,
          ]);

          expect(
            craft(),
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
        },
      );

      test(
        'soaks two algae in clean water and gives the SODIS bottle back',
        () async {
          onBench(const [
            WorkbenchItem.item(.algae),
            WorkbenchItem.item(.algae),
            WorkbenchItem.item(.sodisCleanWater),
            null,
          ]);

          expect(
            craft(),
            isTrue,
          );
          expect(
            deps.inventory.count(.algaeSoaked),
            2,
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
          onBench(const [WorkbenchItem.item(.cleanWater), WorkbenchItem.item(.algae), null, null]);

          expect(
            craft(),
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
          onBench(const [WorkbenchItem.item(.algae), WorkbenchItem.item(.bottleFilteredWater), null, null]);

          expect(
            craft(),
            isTrue,
          );
          expect(
            deps.material.count(.plastic),
            1,
          );
        },
      );

      test(
        'algae do not soak in dirty water or with too many algae and stay on the workbench',
        () {
          onBench(const [WorkbenchItem.item(.algae), WorkbenchItem.item(.sodisLakeWater), null, null]);
          expect(
            craft(),
            isFalse,
          );

          onBench(const [
            WorkbenchItem.item(.algae),
            WorkbenchItem.item(.algae),
            WorkbenchItem.item(.algae),
            WorkbenchItem.item(.cleanWater),
          ]);
          expect(
            craft(),
            isFalse,
          );
          expect(
            deps.workbench.slots.nonNulls,
            hasLength(4),
          );
        },
      );

      test(
        'every first craft writes a book record, repeats do not',
        () {
          onBench(const [WorkbenchItem.material(.metal), null, null, null]);
          craft();
          onBench(const [WorkbenchItem.material(.metal), null, null, null]);
          craft();
          onBench(const [WorkbenchItem.item(.algae), WorkbenchItem.item(.cleanWater), null, null]);
          craft();

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
        'a set that makes nothing stays on the workbench',
        () async {
          onBench(const [WorkbenchItem.material(.metal), WorkbenchItem.material(.metal), null, null]);

          expect(
            craft(),
            isFalse,
          );
          expect(
            deps.workbench.slots.nonNulls,
            hasLength(2),
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
          onBench(const [WorkbenchItem.material(.metal), null, null, null]);

          expect(
            craft(),
            isFalse,
          );
          expect(
            deps.workbench.slots.first,
            const WorkbenchItem.material(.metal),
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
