import 'dart:async';

import 'package:domain/fridge/model/fridge.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';

final class FridgeRepositoryImpl implements FridgeRepository {
  final _fridgeController = StreamController<Fridge>.broadcast();
  Fridge _fridge = const .empty();

  @override
  Fridge get fridge => _fridge;

  @override
  Stream<Fridge> get fridgeStream => _fridgeController.stream;

  @override
  bool put(
    int slot,
    InventoryItem item,
  ) {
    if (!_fridge.canPut(
      slot,
      item,
    )) {
      return false;
    }
    final stack = _fridge.slots[slot];
    _updateSlot(
      slot,
      stack == null
          ? InventoryStack(
              item: item,
              count: 1,
            )
          : stack.copyWith(count: stack.count + 1),
    );
    return true;
  }

  @override
  InventoryItem? take(int slot) {
    final stack = _fridge.slots.elementAtOrNull(slot);
    if (stack == null) {
      return null;
    }
    _updateSlot(
      slot,
      stack.count > 1 ? stack.copyWith(count: stack.count - 1) : null,
    );
    return stack.item;
  }

  @override
  void water(int day) => _update(_fridge.copyWith(wateredDay: () => day));

  @override
  void restore(Fridge fridge) => _update(fridge);

  @override
  void reset() => _update(const .empty());

  void _updateSlot(
    int slot,
    InventoryStack? stack,
  ) => _update(
    _fridge.copyWith(
      slots: List.unmodifiable([
        for (final (index, current) in _fridge.slots.indexed) index == slot ? stack : current,
      ]),
    ),
  );

  void _update(Fridge fridge) {
    _fridge = fridge;
    _fridgeController.add(fridge);
  }
}
