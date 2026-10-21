import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/player/model/meals_eaten.dart';

abstract interface class MealRepository {
  MealsEaten get meals;

  void eat(
    InventoryItem item,
    int day,
  );

  void restore(MealsEaten meals);

  void reset();
}
