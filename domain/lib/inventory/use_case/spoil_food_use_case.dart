import 'package:domain/day/repository/clock_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/progress/model/game_level.dart';

final class SpoilFoodUseCase {
  final ClockRepository _clockRepository;
  final DayRepository _dayRepository;
  final FeedbackRepository _feedbackRepository;
  final FridgeRepository _fridgeRepository;
  final InventoryRepository _inventoryRepository;

  const SpoilFoodUseCase({
    required this._clockRepository,
    required this._dayRepository,
    required this._feedbackRepository,
    required this._fridgeRepository,
    required this._inventoryRepository,
  });

  void call(GameLevel level) {
    if (!level.hasSpoilage || _dayRepository.outcome != null || _clockRepository.isPaused) {
      return;
    }
    final spoiled = {
      ..._inventoryRepository.ageFood(),
      if (!_fridgeRepository.fridge.isCoolingOn(_dayRepository.day.number)) ..._fridgeRepository.ageFood(),
    };
    if (spoiled.isEmpty) {
      return;
    }
    _feedbackRepository.show(
      FeedbackMessage(
        text: [for (final item in spoiled) 'Your ${_name(item)} went bad'].join('\n'),
        mood: .sad,
      ),
    );
  }

  static String _name(InventoryItem item) => switch (item) {
    .cattailRoot => 'cattail roots',
    .cattailRootCooked => 'cooked cattail roots',
    .algae => 'algae',
    .algaeSoaked => 'soaked algae',
    .berries => 'berries',
    .mushrooms => 'mushrooms',
    .mushroomsCooked => 'cooked mushrooms',
    .potato => 'potatoes',
    .potatoBoiled => 'boiled potatoes',
    .cleanWater ||
    .sodisLakeWater ||
    .bottleLakeWater ||
    .sodisStrainedWater ||
    .bottleStrainedWater ||
    .sodisFilteredWater ||
    .bottleFilteredWater ||
    .sodisCleanWater ||
    .sodisBottle ||
    .prefilter ||
    .cookingPot ||
    .rocketStove ||
    .waterFilter ||
    .clayFridge ||
    .gardenBed ||
    .greenhouse => 'food',
  };
}
