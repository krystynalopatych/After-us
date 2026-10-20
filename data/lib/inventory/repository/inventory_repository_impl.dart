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
  int count(InventoryItem item) =>
      _stacks.where((stack) => stack.item == item).fold(0, (sum, stack) => sum + stack.count);

  @override
  bool add(InventoryItem item) {
    final index = _stacks.indexWhere((stack) => stack.item == item && stack.count < _stackSize);
    if (index != -1) {
      _stacks[index] = InventoryStack(item: item, count: _stacks[index].count + 1);
    } else if (_stacks.length < _slotCount) {
      _stacks.add(InventoryStack(item: item, count: 1));
    } else {
      return false;
    }
    _stacksController.add(stacks);
    return true;
  }

  @override
  bool remove(InventoryItem item) {
    final index = _stacks.lastIndexWhere((stack) => stack.item == item);
    if (index == -1) {
      return false;
    }
    final count = _stacks[index].count;
    if (count > 1) {
      _stacks[index] = InventoryStack(item: item, count: count - 1);
    } else {
      _stacks.removeAt(index);
    }
    _stacksController.add(stacks);
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
}
