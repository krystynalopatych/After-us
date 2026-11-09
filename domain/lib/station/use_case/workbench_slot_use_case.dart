import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/repository/workbench_repository.dart';

final class WorkbenchSlotUseCase {
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;
  final WorkbenchRepository _workbenchRepository;

  const WorkbenchSlotUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
    required this._workbenchRepository,
  });

  void call(int index) {
    final selection = _selectionRepository.selection;
    final selected = switch ((selection.material, selection.slot)) {
      (final material?, _) => WorkbenchItem.material(material),
      (_, final slot?) => switch (_inventoryRepository.stacks.elementAtOrNull(slot)?.item) {
        final item? => WorkbenchItem.item(item),
        null => null,
      },
      _ => null,
    };
    final current = _workbenchRepository.slots[index];
    if (selected == null) {
      if (current != null) {
        _giveBack(current);
        _workbenchRepository.setSlot(
          index,
          null,
        );
      }
      return;
    }
    if (switch (selection.slot) {
      final slot? when selection.material == null => _inventoryRepository.stacks[slot].isSpoiled,
      _ => false,
    }) {
      _feedbackRepository.show(const FeedbackMessage(text: 'This food went bad'));
      return;
    }
    final isLastOfStack = switch (selection.slot) {
      final slot? when selection.material == null => _inventoryRepository.stacks[slot].count == 1,
      _ => false,
    };
    if (!_take(
      selected,
      selection.slot,
    )) {
      _feedbackRepository.show(FeedbackMessage(text: 'You have no more ${selected.material?.name ?? 'of it'}'));
      return;
    }
    if (current != null) {
      _giveBack(current);
    }
    _workbenchRepository.setSlot(
      index,
      selected,
    );
    if (isLastOfStack || _owned(selected) == 0) {
      _selectionRepository.reset();
    }
  }

  bool _take(
    WorkbenchItem item,
    int? slot,
  ) => switch ((item, slot)) {
    (WorkbenchItem(:final material?), _) when _materialRepository.count(material) > 0 => _materialRepository.remove(
      material,
      1,
    ),
    (WorkbenchItem(item: _?), final slot?) => _inventoryRepository.takeAt(slot) != null,
    _ => false,
  };

  void _giveBack(WorkbenchItem item) {
    if (item.material case final material?) {
      _materialRepository.add(material);
    }
    if (item.item case final inventoryItem?) {
      _inventoryRepository.add(inventoryItem);
    }
  }

  int _owned(WorkbenchItem item) => switch (item) {
    WorkbenchItem(:final material?) => _materialRepository.count(material),
    WorkbenchItem(:final item?) => _inventoryRepository.count(item),
    _ => 0,
  };
}
