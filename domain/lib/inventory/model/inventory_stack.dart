import 'package:domain/inventory/model/inventory_item.dart';

final class InventoryStack {
  final InventoryItem item;
  final int count;

  const InventoryStack({
    required this.item,
    required this.count,
  });
}
