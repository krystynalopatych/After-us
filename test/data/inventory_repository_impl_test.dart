import 'package:data/inventory/repository/inventory_repository_impl.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'stacks the same item up to five and then opens a new slot',
    () {
      final repository = InventoryRepositoryImpl();

      for (var i = 0; i < 7; i++) {
        repository.add(.berries);
      }

      expect(
        repository.stacks.map((stack) => stack.count),
        [5, 2],
      );
      expect(
        repository.stacks.every((stack) => stack.item == InventoryItem.berries),
        isTrue,
      );
    },
  );

  test(
    'keeps different items in separate slots in the order they came',
    () {
      final repository = InventoryRepositoryImpl()
        ..add(.algae)
        ..add(.berries)
        ..add(.algae);

      expect(
        repository.stacks.map((stack) => stack.item),
        [InventoryItem.algae, InventoryItem.berries],
      );
      expect(
        repository.stacks.first.count,
        2,
      );
    },
  );

  test(
    'refuses a new item when all twelve slots are full',
    () {
      final repository = InventoryRepositoryImpl();
      for (var i = 0; i < 60; i++) {
        repository.add(.cattailRoot);
      }

      expect(
        repository.add(.berries),
        isFalse,
      );
      expect(
        repository.add(.cattailRoot),
        isFalse,
      );
      expect(
        repository.stacks,
        hasLength(12),
      );
    },
  );

  test(
    'adds to a non full stack even when all slots are taken',
    () {
      final repository = InventoryRepositoryImpl();
      for (var i = 0; i < 59; i++) {
        repository.add(.cattailRoot);
      }

      expect(
        repository.add(.cattailRoot),
        isTrue,
      );
      expect(
        repository.stacks.last.count,
        5,
      );
    },
  );

  test(
    'emits the stacks on every change and supports restore and reset',
    () async {
      final repository = InventoryRepositoryImpl();
      final emitted = <List<InventoryStack>>[];
      final subscription = repository.stacksStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository
        ..add(.algae)
        ..restore(const [
          InventoryStack(
            item: .berries,
            count: 3,
          ),
        ]);
      await pumpEventQueue();

      expect(
        repository.stacks.single.item,
        InventoryItem.berries,
      );
      expect(
        repository.stacks.single.count,
        3,
      );

      repository.reset();
      await pumpEventQueue();

      expect(
        repository.stacks,
        isEmpty,
      );
      expect(
        emitted.map((stacks) => stacks.length),
        [1, 1, 0],
      );
    },
  );

  test(
    'count sums an item over all of its stacks',
    () {
      final repository = InventoryRepositoryImpl();
      for (var i = 0; i < 7; i++) {
        repository.add(.algae);
      }
      repository.add(.berries);

      expect(
        repository.count(.algae),
        7,
      );
      expect(
        repository.count(.berries),
        1,
      );
      expect(
        repository.count(.cleanWater),
        0,
      );
    },
  );

  test(
    'remove takes one item from the last stack and drops empty stacks',
    () {
      final repository = InventoryRepositoryImpl();
      for (var i = 0; i < 6; i++) {
        repository.add(.algae);
      }

      expect(
        repository.remove(.algae),
        isTrue,
      );
      expect(
        repository.stacks.map((stack) => stack.count),
        [5],
      );
      expect(
        repository.remove(.algae),
        isTrue,
      );
      expect(
        repository.stacks.map((stack) => stack.count),
        [4],
      );
    },
  );

  test(
    'remove fails for an item that is not in the inventory',
    () {
      final repository = InventoryRepositoryImpl()..add(.berries);

      expect(
        repository.remove(.algae),
        isFalse,
      );
      expect(
        repository.count(.berries),
        1,
      );
    },
  );

  test(
    'does not let callers change the stacks list',
    () {
      final repository = InventoryRepositoryImpl()..add(.algae);

      expect(
        () => repository.stacks.clear(),
        throwsUnsupportedError,
      );
    },
  );

  test(
    'replace swaps one item for several results',
    () {
      final repository = InventoryRepositoryImpl()..add(.sodisLakeWater);

      expect(
        repository.replace(
          .sodisLakeWater,
          [.cleanWater, .cleanWater],
        ),
        isTrue,
      );
      expect(
        repository.stacks,
        const [
          InventoryStack(
            item: .cleanWater,
            count: 2,
          ),
        ],
      );
    },
  );

  test(
    'replace uses the slot freed by the last removed item',
    () {
      final repository = InventoryRepositoryImpl();
      for (var i = 0; i < 55; i++) {
        repository.add(.berries);
      }
      repository.add(.cattailRoot);

      expect(
        repository.canReplace(
          .cattailRoot,
          [.cattailRootCooked],
        ),
        isTrue,
      );
      expect(
        repository.replace(
          .cattailRoot,
          [.cattailRootCooked],
        ),
        isTrue,
      );
      expect(
        repository.count(.cattailRootCooked),
        1,
      );
      expect(
        repository.count(.cattailRoot),
        0,
      );
    },
  );

  test(
    'replace changes nothing when the results do not fit',
    () {
      final repository = InventoryRepositoryImpl();
      for (var i = 0; i < 55; i++) {
        repository.add(.berries);
      }
      repository
        ..add(.sodisLakeWater)
        ..add(.sodisLakeWater);
      final before = repository.stacks;

      expect(
        repository.canReplace(
          .sodisLakeWater,
          [.cleanWater, .cleanWater],
        ),
        isFalse,
      );
      expect(
        repository.replace(
          .sodisLakeWater,
          [.cleanWater, .cleanWater],
        ),
        isFalse,
      );
      expect(
        repository.stacks,
        before,
      );
    },
  );

  test(
    'replace fails for an item that is not in the inventory',
    () {
      final repository = InventoryRepositoryImpl()..add(.berries);

      expect(
        repository.replace(
          .sodisLakeWater,
          [.cleanWater, .cleanWater],
        ),
        isFalse,
      );
      expect(
        repository.count(.berries),
        1,
      );
    },
  );
}
