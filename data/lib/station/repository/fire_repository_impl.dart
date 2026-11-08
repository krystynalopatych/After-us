import 'package:domain/station/model/campfire_recipe.dart';
import 'package:domain/station/repository/fire_repository.dart';

final class FireRepositoryImpl implements FireRepository {
  CampfireRecipe? _recipe;

  @override
  CampfireRecipe? get recipe => _recipe;

  @override
  void load(CampfireRecipe recipe) => _recipe = recipe;

  @override
  void reset() => _recipe = null;
}
