import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/station/model/campfire_recipe.dart';
import 'package:domain/station/repository/fire_repository.dart';
import 'package:domain/station/repository/workbench_repository.dart';

final class ReturnStationItemsUseCase {
  final FireRepository _fireRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final WorkbenchRepository _workbenchRepository;

  const ReturnStationItemsUseCase({
    required this._fireRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._workbenchRepository,
  });

  void call() {
    for (final (index, slot) in _workbenchRepository.slots.indexed) {
      if (slot == null) {
        continue;
      }
      if (slot.material case final material?) {
        _materialRepository.add(material);
      }
      if (slot.item case final item?) {
        _inventoryRepository.add(item);
      }
      _workbenchRepository.setSlot(
        index,
        null,
      );
    }
    switch (_fireRepository.recipe) {
      case CampfireRecipe(:final input?):
        _inventoryRepository.add(input);
      case CampfireRecipe(:final material?, :final materialCount):
        for (var i = 0; i < materialCount; i++) {
          _materialRepository.add(material);
        }
      case _:
        break;
    }
    _fireRepository.reset();
  }
}
