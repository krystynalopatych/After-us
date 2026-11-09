import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';

final class FridgeSlotUseCase {
  final FeedbackRepository _feedbackRepository;
  final FridgeRepository _fridgeRepository;
  final InventoryRepository _inventoryRepository;
  final SelectionRepository _selectionRepository;

  const FridgeSlotUseCase({
    required this._feedbackRepository,
    required this._fridgeRepository,
    required this._inventoryRepository,
    required this._selectionRepository,
  });

  void call(int slot) {
    final selected = _selectionRepository.selection.slot;
    if (selected == null || _inventoryRepository.stacks.elementAtOrNull(selected) == null) {
      _take(slot);
      return;
    }
    _put(
      slot,
      selected,
    );
  }

  void _put(
    int slot,
    int inventorySlot,
  ) {
    final stack = _inventoryRepository.stacks[inventorySlot];
    if (!stack.item.isPerishable) {
      _show('Only food goes into the fridge');
      return;
    }
    if (!_fridgeRepository.fridge.canPut(
      slot,
      stack.item,
      age: stack.age,
    )) {
      _show('There is no room for it here');
      return;
    }
    _inventoryRepository.takeAt(inventorySlot);
    _fridgeRepository.put(
      slot,
      stack.item,
      age: stack.age,
    );
    if (stack.count == 1) {
      _selectionRepository.reset();
    }
  }

  void _take(int slot) {
    final stack = _fridgeRepository.fridge.slots.elementAtOrNull(slot);
    if (stack == null) {
      return;
    }
    if (!_inventoryRepository.add(
      stack.item,
      age: stack.age,
    )) {
      _show('Your inventory is full');
      return;
    }
    _fridgeRepository.take(slot);
  }

  void _show(String text) => _feedbackRepository.show(FeedbackMessage(text: text));
}
