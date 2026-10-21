import 'package:domain/inventory/model/water_bottle.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';

final class WaterBottlesUseCase {
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;

  const WaterBottlesUseCase({
    required this._inventoryRepository,
    required this._materialRepository,
  });

  Set<WaterBottle> call() => {
    if (_inventoryRepository.count(.sodisBottle) > 0) WaterBottle.sodis,
    if (_materialRepository.count(.plastic) > 0) WaterBottle.plastic,
  };
}
