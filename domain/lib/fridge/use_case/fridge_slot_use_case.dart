import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
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
    final selected = switch (_selectionRepository.selection.slot) {
      final index? => _inventoryRepository.stacks.elementAtOrNull(index)?.item,
      null => null,
    };
    if (selected == null) {
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
    InventoryItem item,
  ) {
    if (!_isFood(item)) {
      _show('Only food goes into the fridge');
      return;
    }
    if (!_fridgeRepository.fridge.canPut(
      slot,
      item,
    )) {
      _show('There is no room for it here');
      return;
    }
    _inventoryRepository.remove(item);
    _fridgeRepository.put(
      slot,
      item,
    );
    if (_inventoryRepository.count(item) == 0) {
      _selectionRepository.reset();
    }
  }

  void _take(int slot) {
    final stack = _fridgeRepository.fridge.slots.elementAtOrNull(slot);
    if (stack == null) {
      return;
    }
    if (!_inventoryRepository.add(stack.item)) {
      _show('Your inventory is full');
      return;
    }
    _fridgeRepository.take(slot);
  }

  void _show(String text) => _feedbackRepository.show(FeedbackMessage(text: text));

  static bool _isFood(InventoryItem item) => item.hunger > 0 && !item.isDrink;
}
