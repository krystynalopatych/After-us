import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';

final class FillBottleUseCase {
  static const _bottlePlastic = 1;

  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const FillBottleUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  bool call() {
    final usesPlastic = _selectionRepository.selection.material == GameMaterial.plastic;
    if (!usesPlastic && _inventoryRepository.count(.sodisBottle) == 0) {
      _feedbackRepository.show(const FeedbackMessage(text: 'You need a bottle to carry lake water'));
      return false;
    }
    if (!_inventoryRepository.add(usesPlastic ? InventoryItem.lakeWaterBottle : InventoryItem.lakeWater)) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Your inventory is full'));
      return false;
    }
    if (usesPlastic) {
      _materialRepository.remove(
        .plastic,
        _bottlePlastic,
      );
      if (_materialRepository.count(.plastic) == 0) {
        _selectionRepository.reset();
      }
    }
    _feedbackRepository.show(
      FeedbackMessage(
        text: usesPlastic ? 'You filled a plastic bottle with lake water' : 'You filled a bottle with lake water',
        heroLine: 'Drinking it as is will make me sick.',
      ),
    );
    return true;
  }
}
