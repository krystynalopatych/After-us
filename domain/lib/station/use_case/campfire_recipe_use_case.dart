import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/campfire_recipe.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/repository/fire_repository.dart';

final class CampfireRecipeUseCase {
  final FeedbackRepository _feedbackRepository;
  final FireRepository _fireRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const CampfireRecipeUseCase({
    required this._feedbackRepository,
    required this._fireRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  CampfireRecipe? call(Station station) {
    final selection = _selectionRepository.selection;
    final item = switch (selection.slot) {
      final slot? => _inventoryRepository.stacks.elementAtOrNull(slot)?.item,
      null => null,
    };
    final material = selection.material;
    if (item == null && material == null) {
      return null;
    }
    final recipe = switch ((item, material)) {
      (final item?, _) => CampfireRecipe.fromItem(item),
      (_, final material?) => CampfireRecipe.fromMaterial(material),
      _ => null,
    };
    final problem = switch (recipe) {
      null => "You can't use this here",
      CampfireRecipe(:final material?, :final materialCount) when _materialRepository.count(material) < materialCount =>
        'You need $materialCount ${material.name} for this',
      CampfireRecipe(needsCookingPot: true) when _inventoryRepository.count(.cookingPot) == 0 =>
        'You need a cooking pot',
      CampfireRecipe(:final input?)
          when !_inventoryRepository.canReplace(
            input,
            recipe.outputsOn(station),
          ) =>
        'Your inventory is full',
      _ => null,
    };
    if (problem != null || recipe == null) {
      _feedbackRepository.show(FeedbackMessage(text: problem ?? "You can't use this here"));
      return null;
    }
    if (recipe case CampfireRecipe(:final input?)) {
      _inventoryRepository.remove(input);
    }
    if (recipe case CampfireRecipe(:final material?, :final materialCount)) {
      _materialRepository.remove(
        material,
        materialCount,
      );
    }
    _fireRepository.load(recipe);
    _selectionRepository.reset();
    _feedbackRepository.show(
      const FeedbackMessage(text: 'Click on an item to use for starting a fire'),
    );
    return recipe;
  }
}
