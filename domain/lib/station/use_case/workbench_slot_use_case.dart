import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/workbench_item.dart';

final class WorkbenchSlotUseCase {
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const WorkbenchSlotUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  List<WorkbenchItem?> call(
    List<WorkbenchItem?> slots,
    int index,
  ) {
    final selection = _selectionRepository.selection;
    final selected = switch ((selection.material, selection.slot)) {
      (final material?, _) => WorkbenchItem.material(material),
      (_, final slot?) => switch (_inventoryRepository.stacks.elementAtOrNull(slot)?.item) {
        final item? => WorkbenchItem.item(item),
        null => null,
      },
      _ => null,
    };
    if (selected == null) {
      return _withSlot(
        slots,
        index,
        null,
      );
    }
    final reserved = slots.indexed.where((entry) => entry.$1 != index && entry.$2 == selected).length;
    final owned = switch (selected) {
      WorkbenchItem(:final material?) => _materialRepository.count(material),
      WorkbenchItem(:final item?) => _inventoryRepository.count(item),
      _ => 0,
    };
    if (owned <= reserved) {
      _feedbackRepository.show(FeedbackMessage(text: 'You have no more ${selected.material?.name ?? 'of it'}'));
      return slots;
    }
    return _withSlot(
      slots,
      index,
      selected,
    );
  }

  static List<WorkbenchItem?> _withSlot(
    List<WorkbenchItem?> slots,
    int index,
    WorkbenchItem? selected,
  ) => [
    for (final (slotIndex, slot) in slots.indexed) slotIndex == index ? selected : slot,
  ];
}
