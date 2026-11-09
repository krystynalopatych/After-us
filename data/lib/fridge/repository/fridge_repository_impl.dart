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
    InventoryItem item, {
    int age = 0,
  }) {
    if (!_fridge.canPut(
      slot,
      item,
      age: age,
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
              age: age,
            )
          : stack.merged(age),
    );
    return true;
  }

  @override
  InventoryStack? take(int slot) {
    final stack = _fridge.slots.elementAtOrNull(slot);
    if (stack == null) {
      return null;
    }
    _updateSlot(
      slot,
      stack.count > 1 ? stack.copyWith(count: stack.count - 1) : null,
    );
    return stack.copyWith(count: 1);
  }

  @override
  List<InventoryItem> ageFood() {
    final spoiled = <InventoryItem>[];
    final slots = [
      for (final stack in _fridge.slots)
        if (stack == null || stack.isSpoiled) stack else stack.copyWith(age: stack.age + 1),
    ];
    if (slots.nonNulls.isEmpty) {
      return spoiled;
    }
    for (final (index, stack) in slots.indexed) {
      if (stack != null && stack.isSpoiled && !(_fridge.slots[index]?.isSpoiled ?? false)) {
        spoiled.add(stack.item);
      }
    }
    _update(_fridge.copyWith(slots: List.unmodifiable(slots)));
    return spoiled;
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
