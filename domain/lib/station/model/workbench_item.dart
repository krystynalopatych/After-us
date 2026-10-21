import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:equatable/equatable.dart';

final class WorkbenchItem extends Equatable {
  final GameMaterial? material;
  final InventoryItem? item;

  const WorkbenchItem.material(GameMaterial this.material) : item = null;

  const WorkbenchItem.item(InventoryItem this.item) : material = null;

  const WorkbenchItem._({
    this.material,
    this.item,
  });

  WorkbenchItem copyWith({
    GameMaterial? Function()? material,
    InventoryItem? Function()? item,
  }) => WorkbenchItem._(
    material: material != null ? material() : this.material,
    item: item != null ? item() : this.item,
  );

  @override
  List<Object?> get props => [material, item];
}
