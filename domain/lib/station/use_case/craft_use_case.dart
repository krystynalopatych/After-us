import 'package:domain/book/model/book_record.dart';
import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/model/workbench_recipe.dart';

final class CraftUseCase {
  static const _algaePerWater = 2;

  final BookRepository _bookRepository;
  final ConstructionRepository _constructionRepository;
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const CraftUseCase({
    required this._bookRepository,
    required this._constructionRepository,
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  bool call(List<WorkbenchItem?> slots) {
    final placed = slots.nonNulls;
    final materials = <GameMaterial, int>{};
    for (final material in placed.map((slot) => slot.material).nonNulls) {
      materials.update(
        material,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final items = placed.map((slot) => slot.item).nonNulls.toList();
    final isCrafted = items.isEmpty
        ? _craft(materials)
        : _soakAlgae(
            materials,
            items,
          );
    if (isCrafted) {
      _selectionRepository.reset();
    }
    return isCrafted;
  }

  bool _craft(Map<GameMaterial, int> materials) {
    final recipe = WorkbenchRecipe.fromMaterials(materials);
    if (recipe == null) {
      _show(const FeedbackMessage(text: 'Nothing can be crafted from this'));
      return false;
    }
    if (materials.entries.any((entry) => _materialRepository.count(entry.key) < entry.value)) {
      _show(const FeedbackMessage(text: 'Not enough materials'));
      return false;
    }
    if (!_inventoryRepository.add(recipe.result)) {
      _show(const FeedbackMessage(text: 'Your inventory is full'));
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
    _bookRepository.write(recipe.record);
    _show(
      FeedbackMessage(
        text: _text(recipe),
        mood: .happy,
      ),
    );
    return true;
  }

  bool _soakAlgae(
    Map<GameMaterial, int> materials,
    List<InventoryItem> items,
  ) {
    final algae = items.where((item) => item == .algae).length;
    final waters = items.where((item) => item.water?.isClean ?? false).toList();
    if (materials.isNotEmpty ||
        waters.length != 1 ||
        algae == 0 ||
        algae > _algaePerWater ||
        algae + 1 != items.length) {
      _show(const FeedbackMessage(text: 'Nothing can be crafted from this'));
      return false;
    }
    final water = waters.single;
    if (!_inventoryRepository.exchange(
      items,
      [
        ...List.filled(
          algae,
          InventoryItem.algaeSoaked,
        ),
        ?water.emptyBottle,
      ],
    )) {
      _show(const FeedbackMessage(text: 'Your inventory is full'));
      return false;
    }
    if (water.container case final container?) {
      _materialRepository.add(container);
    }
    _bookRepository.write(BookRecord.soakedAlgae);
    _show(
      FeedbackMessage(
        text: 'You soaked the algae +$algae soaked algae',
        mood: .happy,
      ),
    );
    return true;
  }

  void _show(FeedbackMessage message) => _feedbackRepository.show(message);

  static String _text(WorkbenchRecipe recipe) => switch (recipe) {
    .sodisBottle => 'You crafted a SODIS bottle',
    .prefilter => 'You crafted a cloth prefilter',
    .cookingPot => 'You crafted a cooking pot',
    .rocketStove => 'You built a rocket stove',
    .waterFilter => 'You built a water filter',
  };
}
