import 'package:data/fridge/repository/fridge_repository_impl.dart';
import 'package:domain/fridge/model/fridge.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts empty and not watered',
    () {
      final fridge = FridgeRepositoryImpl().fridge;

      expect(
        fridge,
        const Fridge.empty(),
      );
      expect(
        fridge.isCoolingOn(1),
        isFalse,
      );
    },
  );

  test(
    'stacks up to five of the same food in one slot',
    () {
      final repository = FridgeRepositoryImpl();
      for (var i = 0; i < Fridge.stackSize; i++) {
        expect(
          repository.put(
            2,
            .berries,
          ),
          isTrue,
        );
      }

      expect(
        repository.put(
          2,
          .berries,
        ),
        isFalse,
      );
      expect(
        repository.put(
          2,
          .algae,
        ),
        isFalse,
      );
      expect(
        repository.fridge.slots,
        [
          null,
          null,
          const InventoryStack(
            item: .berries,
            count: 5,
          ),
          null,
        ],
      );
    },
  );

  test(
    'refuses slots outside the fridge',
    () {
      expect(
        FridgeRepositoryImpl().put(
          Fridge.slotCount,
          .berries,
        ),
        isFalse,
      );
    },
  );

  test(
    'take gives back one portion and empties the slot at the end',
    () async {
      final repository = FridgeRepositoryImpl()
        ..put(
          0,
          .algae,
        )
        ..put(
          0,
          .algae,
        );
      final emitted = <Fridge>[];
      final subscription = repository.fridgeStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      expect(
        repository.take(0),
        InventoryItem.algae,
      );
      expect(
        repository.take(0),
        InventoryItem.algae,
      );
      expect(
        repository.take(0),
        isNull,
      );
      await pumpEventQueue();

      expect(
        repository.fridge.slots.first,
        isNull,
      );
      expect(
        emitted,
        hasLength(2),
      );
    },
  );

  test(
    'watering keeps the fridge cold only on that day',
    () {
      final repository = FridgeRepositoryImpl()..water(2);

      expect(
        repository.fridge.isCoolingOn(2),
        isTrue,
      );
      expect(
        repository.fridge.isCoolingOn(3),
        isFalse,
      );
    },
  );

  test(
    'restore and reset replace the whole fridge',
    () {
      const saved = Fridge(
        slots: [
          InventoryStack(
            item: .mushrooms,
            count: 1,
          ),
          null,
          null,
          null,
        ],
        wateredDay: 1,
      );
      final repository = FridgeRepositoryImpl()..restore(saved);

      expect(
        repository.fridge,
        saved,
      );

      repository.reset();
      expect(
        repository.fridge,
        const Fridge.empty(),
      );
    },
  );
}
