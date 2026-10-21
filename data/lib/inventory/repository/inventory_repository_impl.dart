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
  bool add(InventoryItem item) {
    if (!_addTo(
      _stacks,
      item,
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
  bool canReplace(
    InventoryItem item,
    InventoryItem result,
    int count,
  ) =>
      _replaced(
        item,
        result,
        count,
      ) !=
      null;

  @override
  bool replace(
    InventoryItem item,
    InventoryItem result,
    int count,
  ) {
    final replaced = _replaced(
      item,
      result,
      count,
    );
    if (replaced == null) {
      return false;
    }
    restore(replaced);
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

  List<InventoryStack>? _replaced(
    InventoryItem item,
    InventoryItem result,
    int count,
  ) {
    final stacks = [..._stacks];
    if (!_removeFrom(
      stacks,
      item,
    )) {
      return null;
    }
    for (var i = 0; i < count; i++) {
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
    InventoryItem item,
  ) {
    final index = stacks.indexWhere((stack) => stack.item == item && stack.count < _stackSize);
    if (index != -1) {
      stacks[index] = stacks[index].copyWith(count: stacks[index].count + 1);
      return true;
    }
    if (stacks.length >= _slotCount) {
      return false;
    }
    stacks.add(
      InventoryStack(
        item: item,
        count: 1,
      ),
    );
    return true;
  }

  static bool _removeFrom(
    List<InventoryStack> stacks,
    InventoryItem item,
  ) {
    final index = stacks.lastIndexWhere((stack) => stack.item == item);
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
