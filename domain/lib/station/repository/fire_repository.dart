import 'package:domain/station/model/campfire_recipe.dart';

abstract interface class FireRepository {
  CampfireRecipe? get recipe;

  void load(CampfireRecipe recipe);

  void reset();
}
