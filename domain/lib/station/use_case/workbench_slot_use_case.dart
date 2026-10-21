import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';

final class WorkbenchSlotUseCase {
  final FeedbackRepository _feedbackRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const WorkbenchSlotUseCase({
    required this._feedbackRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  List<GameMaterial?> call(
    List<GameMaterial?> slots,
    int index,
  ) {
    final selection = _selectionRepository.selection;
    if (selection.slot != null) {
      _feedbackRepository.show(const FeedbackMessage(text: "You can't use this at the workbench"));
      return slots;
    }
    final material = selection.material;
    if (material == null) {
      return _withSlot(
        slots,
        index,
        null,
      );
    }
    final reserved = slots.indexed.where((entry) => entry.$1 != index && entry.$2 == material).length;
    if (_materialRepository.count(material) <= reserved) {
      _feedbackRepository.show(FeedbackMessage(text: 'You have no more ${material.name}'));
      return slots;
    }
    return _withSlot(
      slots,
      index,
      material,
    );
  }

  static List<GameMaterial?> _withSlot(
    List<GameMaterial?> slots,
    int index,
    GameMaterial? material,
  ) => [
    for (final (slotIndex, slot) in slots.indexed) slotIndex == index ? material : slot,
  ];
}
