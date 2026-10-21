import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';

abstract interface class InventoryRepository {
  List<InventoryStack> get stacks;

  Stream<List<InventoryStack>> get stacksStream;

  int count(InventoryItem item);

  bool add(InventoryItem item);

  bool remove(InventoryItem item);

  bool canReplace(
    InventoryItem item,
    List<InventoryItem> results,
  );

  bool replace(
    InventoryItem item,
    List<InventoryItem> results,
  );

  bool exchange(
    List<InventoryItem> removed,
    List<InventoryItem> added,
  );

  void restore(List<InventoryStack> stacks);

  void reset();
}
