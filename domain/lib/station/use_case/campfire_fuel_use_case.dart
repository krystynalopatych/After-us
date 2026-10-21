import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/campfire_fuel.dart';
import 'package:domain/station/model/campfire_recipe.dart';

final class CampfireFuelUseCase {
  static const _fuelCount = 1;
  static const _recipeMaterialCount = 1;

  final FeedbackRepository _feedbackRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const CampfireFuelUseCase({
    required this._feedbackRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  CampfireFuel? call(
    CampfireRecipe recipe,
    GameMaterial material,
  ) {
    final fuel = CampfireFuel.fromMaterial(material);
    final needed = _fuelCount + (recipe.material == material ? _recipeMaterialCount : 0);
    final problem = switch (fuel) {
      null => "You can't start a fire with this",
      _ when _materialRepository.count(material) < needed => 'You need $needed ${material.name} for this',
      _ => null,
    };
    if (problem != null) {
      _selectionRepository.reset();
      _feedbackRepository.show(FeedbackMessage(text: problem));
      return null;
    }
    return fuel;
  }
}
