import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/water_request.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/selection/repository/selection_repository.dart';

final class LakeWaterRequestUseCase {
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final SelectionRepository _selectionRepository;

  const LakeWaterRequestUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._selectionRepository,
  });

  WaterRequest? call() {
    final selection = _selectionRepository.selection;
    final item = switch (selection.slot) {
      final slot? => _inventoryRepository.stacks.elementAtOrNull(slot)?.item,
      null => null,
    };
    final request = switch ((item, selection.material)) {
      (null, GameMaterial.plastic) => const WaterRequest(
        water: .lake,
        bottle: .plastic,
      ),
      (InventoryItem.sodisBottle, _) => const WaterRequest(
        water: .lake,
        bottle: .sodis,
      ),
      (InventoryItem.prefilter, _) => const WaterRequest(water: .strained),
      (InventoryItem.waterFilter, _) => const WaterRequest(water: .filtered),
      _ => null,
    };
    if (request == null) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Choose a bottle to fill'));
    }
    return request;
  }
}
