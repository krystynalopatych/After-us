import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/campfire_fuel.dart';
import 'package:domain/station/model/campfire_recipe.dart';

final class CookOnCampfireUseCase {
  static const _fuelCount = 1;
  static const _recipeMaterialCount = 1;

  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final PollutionRepository _pollutionRepository;
  final SelectionRepository _selectionRepository;

  const CookOnCampfireUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._pollutionRepository,
    required this._selectionRepository,
  });

  bool call(
    CampfireRecipe recipe,
    CampfireFuel fuel,
  ) {
    final needed = {
      fuel.material: _fuelCount,
    };
    if (recipe.material case final material?) {
      needed.update(
        material,
        (count) => count + _recipeMaterialCount,
        ifAbsent: () => _recipeMaterialCount,
      );
    }
    if (needed.entries.any((entry) => _materialRepository.count(entry.key) < entry.value)) {
      return false;
    }
    if (recipe case CampfireRecipe(:final input?, :final output?)
        when !_inventoryRepository.replace(
          input,
          output,
          recipe.outputCount,
        )) {
      return false;
    }
    for (final MapEntry(key: material, value: count) in needed.entries) {
      _materialRepository.remove(
        material,
        count,
      );
    }
    if (recipe.product case final product?) {
      _materialRepository.add(product);
    }
    if (fuel.isPolluting) {
      _pollutionRepository.addAirPoints(fuel.airPoints);
    }
    _selectionRepository.reset();
    _feedbackRepository.show(
      _message(
        recipe,
        fuel,
      ),
    );
    return true;
  }

  static FeedbackMessage _message(
    CampfireRecipe recipe,
    CampfireFuel fuel,
  ) {
    final text = switch (recipe) {
      .boilWater => 'You boiled lake water +2 clean water',
      .cookCattailRoot => 'You cooked cattail roots',
      .makeCharcoal => 'You made charcoal +1 charcoal',
    };
    if (fuel.isPolluting) {
      return FeedbackMessage(
        text: '$text\nYou burned ${fuel.name} Air quality −${fuel.airPoints}',
        heroLine: 'Cough... Next time I should think harder.',
        mood: .sad,
      );
    }
    return FeedbackMessage(
      text: text,
      heroLine: switch (recipe) {
        .boilWater => "Now it's safe to drink.",
        .cookCattailRoot => 'Warm food at last.',
        .makeCharcoal => 'Charcoal... I can use it for the water filter.',
      },
      mood: .happy,
    );
  }
}
