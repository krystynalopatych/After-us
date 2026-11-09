import 'dart:async';

import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';

final class InventoryRepositoryImpl implements InventoryRepository {
  static const _slotCount = 12;
  static const _stackSize = 5;

  final _stacksController = StreamController<List<InventoryStack>>.broadcast();
  final _stacks = <InventoryStack>[];

  @override
  List<InventoryStack> get stacks => List.unmodifiable(_stacks);

  @override
  Stream<List<InventoryStack>> get stacksStream => _stacksController.stream;

  @override
  int count(InventoryItem item) => _stacks
      .where((stack) => stack.item == item)
      .fold(
        0,
        (sum, stack) => sum + stack.count,
      );

  @override
  bool add(
    InventoryItem item, {
    int age = 0,
  }) {
    if (!_addTo(
      _stacks,
      item,
      age: age,
    )) {
      return false;
    }
    _stacksController.add(stacks);
    return true;
  }

  @override
  bool remove(InventoryItem item) {
    if (!_removeFrom(
      _stacks,
      item,
    )) {
      return false;
    }
    _stacksController.add(stacks);
    return true;
  }

  @override
  InventoryStack? takeAt(int slot) {
    final stack = _stacks.elementAtOrNull(slot);
    if (stack == null) {
      return null;
    }
    if (stack.count > 1) {
      _stacks[slot] = stack.copyWith(count: stack.count - 1);
    } else {
      _stacks.removeAt(slot);
    }
    _stacksController.add(stacks);
    return stack.copyWith(count: 1);
  }

  @override
  List<InventoryItem> ageFood() {
    final spoiled = <InventoryItem>[];
    var isChanged = false;
    for (final (index, stack) in _stacks.indexed) {
      if (!stack.item.isPerishable || stack.isSpoiled) {
        continue;
      }
      final aged = stack.copyWith(age: stack.age + 1);
      _stacks[index] = aged;
      isChanged = true;
      if (aged.isSpoiled) {
        spoiled.add(aged.item);
      }
    }
    if (isChanged) {
      _stacksController.add(stacks);
    }
    return spoiled;
  }

  @override
  bool canReplace(
    InventoryItem item,
    List<InventoryItem> results,
  ) =>
      _exchanged(
        [item],
        results,
      ) !=
      null;

  @override
  bool replace(
    InventoryItem item,
    List<InventoryItem> results,
  ) => exchange(
    [item],
    results,
  );

  @override
  bool exchange(
    List<InventoryItem> removed,
    List<InventoryItem> added,
  ) {
    final exchanged = _exchanged(
      removed,
      added,
    );
    if (exchanged == null) {
      return false;
    }
    restore(exchanged);
    return true;
  }

  @override
  void restore(List<InventoryStack> stacks) {
    _stacks
      ..clear()
      ..addAll(stacks);
    _stacksController.add(this.stacks);
  }

  @override
  void reset() {
    _stacks.clear();
    _stacksController.add(stacks);
  }

  List<InventoryStack>? _exchanged(
    List<InventoryItem> removed,
    List<InventoryItem> added,
  ) {
    final stacks = [..._stacks];
    for (final item in removed) {
      if (!_removeFrom(
        stacks,
        item,
      )) {
        return null;
      }
    }
    for (final result in added) {
      if (!_addTo(
        stacks,
        result,
      )) {
        return null;
      }
    }
    return stacks;
  }

  static bool _addTo(
    List<InventoryStack> stacks,
    InventoryItem item, {
    int age = 0,
  }) {
    final index = stacks.indexWhere(
      (stack) =>
          stack.canTake(
            item,
            age,
          ) &&
          stack.count < _stackSize,
    );
    if (index != -1) {
      stacks[index] = stacks[index].merged(age);
      return true;
    }
    if (stacks.length >= _slotCount) {
      return false;
    }
    stacks.add(
      InventoryStack(
        item: item,
        count: 1,
        age: age,
      ),
    );
    return true;
  }

  static bool _removeFrom(
    List<InventoryStack> stacks,
    InventoryItem item,
  ) {
    final fresh = stacks.lastIndexWhere((stack) => stack.item == item && !stack.isSpoiled);
    final index = fresh != -1 ? fresh : stacks.lastIndexWhere((stack) => stack.item == item);
    if (index == -1) {
      return false;
    }
    final stack = stacks[index];
    if (stack.count > 1) {
      stacks[index] = stack.copyWith(count: stack.count - 1);
    } else {
      stacks.removeAt(index);
    }
    return true;
  }
}
