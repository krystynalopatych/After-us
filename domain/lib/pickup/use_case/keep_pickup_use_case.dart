import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';

final class KeepPickupUseCase {
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;

  const KeepPickupUseCase({
    required this._inventoryRepository,
    required this._materialRepository,
    required this._pickupRepository,
  });

  bool call(Pickup pickup) {
    if (pickup.kind.material case final material?) {
      _materialRepository.add(material);
    } else if (pickup.kind.food case final food? when !_inventoryRepository.add(food)) {
      return false;
    }
    _pickupRepository.collect(pickup);
    return true;
  }
}
