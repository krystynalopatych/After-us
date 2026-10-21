import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/campfire_recipe.dart';

final class CampfireRecipeUseCase {
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final SelectionRepository _selectionRepository;

  const CampfireRecipeUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._selectionRepository,
  });

  CampfireRecipe? call() {
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
      null => "You can't use this at the campfire",
      _ when _inventoryRepository.count(.cookingPot) == 0 => 'You need a cooking pot',
      CampfireRecipe(:final input?)
          when !_inventoryRepository.canReplace(
            input,
            recipe.outputs,
          ) =>
        'Your inventory is full',
      _ => null,
    };
    if (problem != null) {
      _feedbackRepository.show(FeedbackMessage(text: problem));
      return null;
    }
    _selectionRepository.reset();
    _feedbackRepository.show(
      const FeedbackMessage(text: 'Click on an item to use for starting a fire'),
    );
    return recipe;
  }
}
