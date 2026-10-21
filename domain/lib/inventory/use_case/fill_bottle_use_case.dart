import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/water_bottle.dart';
import 'package:domain/inventory/model/water_kind.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
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

  bool call(
    WaterBottle bottle,
    WaterKind water,
  ) {
    final filled = InventoryItem.filledWith(
      water,
      bottle,
    );
    final hasBottle = switch (bottle) {
      .sodis => _inventoryRepository.count(.sodisBottle) > 0,
      .plastic => _materialRepository.count(.plastic) > 0,
    };
    if (!hasBottle) {
      _feedbackRepository.show(FeedbackMessage(text: _missingText(bottle)));
      return false;
    }
    final isStored = switch (bottle) {
      .sodis => _inventoryRepository.replace(
        .sodisBottle,
        [filled],
      ),
      .plastic => _inventoryRepository.add(filled),
    };
    if (!isStored) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Your inventory is full'));
      return false;
    }
    if (bottle == .plastic) {
      _materialRepository.remove(
        .plastic,
        _bottlePlastic,
      );
    }
    final selection = _selectionRepository.selection;
    if (selection.slot != null || (selection.material != null && _materialRepository.count(.plastic) == 0)) {
      _selectionRepository.reset();
    }
    _feedbackRepository.show(FeedbackMessage(text: 'You filled a ${_bottleName(bottle)} with ${_waterName(water)}'));
    return true;
  }

  static String _missingText(WaterBottle bottle) => switch (bottle) {
    .sodis => 'You have no empty SODIS bottle',
    .plastic => 'You have no plastic bottle',
  };

  static String _bottleName(WaterBottle bottle) => switch (bottle) {
    .sodis => 'SODIS bottle',
    .plastic => 'plastic bottle',
  };

  static String _waterName(WaterKind water) => switch (water) {
    .lake => 'lake water',
    .strained => 'strained water',
    .filtered => 'filtered water',
    .disinfected || .boiled => 'clean water',
  };
}
