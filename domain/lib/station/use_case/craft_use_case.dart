import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/workbench_recipe.dart';

final class CraftUseCase {
  final ConstructionRepository _constructionRepository;
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const CraftUseCase({
    required this._constructionRepository,
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  bool call(List<GameMaterial?> slots) {
    final materials = <GameMaterial, int>{};
    for (final material in slots.nonNulls) {
      materials.update(
        material,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final recipe = WorkbenchRecipe.fromMaterials(materials);
    if (recipe == null) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Nothing can be crafted from this'));
      return false;
    }
    if (materials.entries.any((entry) => _materialRepository.count(entry.key) < entry.value)) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Not enough materials'));
      return false;
    }
    if (!_inventoryRepository.add(recipe.result)) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Your inventory is full'));
      return false;
    }
    for (final MapEntry(key: material, value: count) in materials.entries) {
      _materialRepository.remove(
        material,
        count,
      );
    }
    if (recipe.construction case final construction?) {
      _constructionRepository.build(construction);
    }
    _selectionRepository.reset();
    _feedbackRepository.show(
      FeedbackMessage(
        text: _text(recipe),
        mood: .happy,
      ),
    );
    return true;
  }

  static String _text(WorkbenchRecipe recipe) => switch (recipe) {
    .sodisBottle => 'You crafted a SODIS bottle',
    .prefilter => 'You crafted a cloth prefilter',
    .cookingPot => 'You crafted a cooking pot',
    .rocketStove => 'You built a rocket stove',
    .waterFilter => 'You built a water filter',
  };
}
