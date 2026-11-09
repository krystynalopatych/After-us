import 'package:domain/fridge/model/fridge.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';

abstract interface class FridgeRepository {
  Fridge get fridge;

  Stream<Fridge> get fridgeStream;

  bool put(
    int slot,
    InventoryItem item, {
    int age,
  });

  InventoryStack? take(int slot);

  List<InventoryItem> ageFood();

  void water(int day);

  void restore(Fridge fridge);

  void reset();
}
