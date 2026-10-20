import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';

abstract interface class InventoryRepository {
  List<InventoryStack> get stacks;

  Stream<List<InventoryStack>> get stacksStream;

  bool add(InventoryItem item);

  void restore(List<InventoryStack> stacks);

  void reset();
}
