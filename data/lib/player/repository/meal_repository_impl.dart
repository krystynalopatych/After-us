import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/player/model/meals_eaten.dart';
import 'package:domain/player/repository/meal_repository.dart';

final class MealRepositoryImpl implements MealRepository {
  MealsEaten _meals = const .none();

  @override
  MealsEaten get meals => _meals;

  @override
  void eat(
    InventoryItem item,
    int day,
  ) => _meals = MealsEaten(
    day: day,
    counts: Map.unmodifiable({
      if (_meals.day == day) ..._meals.counts,
      item:
          _meals.countOn(
            day,
            item,
          ) +
          1,
    }),
  );

  @override
  void restore(MealsEaten meals) => _meals = meals;

  @override
  void reset() => _meals = const .none();
}
