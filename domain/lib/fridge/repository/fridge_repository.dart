import 'package:domain/fridge/model/fridge.dart';
import 'package:domain/inventory/model/inventory_item.dart';

abstract interface class FridgeRepository {
  Fridge get fridge;

  Stream<Fridge> get fridgeStream;

  bool put(
    int slot,
    InventoryItem item,
  );

  InventoryItem? take(int slot);

  void water(int day);

  void restore(Fridge fridge);

  void reset();
}
