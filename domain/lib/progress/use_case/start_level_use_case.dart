import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/compost/repository/compost_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/repository/clock_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/player/repository/meal_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/carry_over_repository.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';
import 'package:domain/station/repository/campfire_repository.dart';
import 'package:domain/station/repository/fire_repository.dart';
import 'package:domain/station/repository/station_repository.dart';
import 'package:domain/station/repository/workbench_repository.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';

final class StartLevelUseCase {
  final CarryOverRepository _carryOverRepository;
  final CharacterRepository _characterRepository;
  final CampfireRepository _campfireRepository;
  final CompostRepository _compostRepository;
  final ClockRepository _clockRepository;
  final ConstructionRepository _constructionRepository;
  final DayRepository _dayRepository;
  final FireRepository _fireRepository;
  final FridgeRepository _fridgeRepository;
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;
  final MealRepository _mealRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;
  final SaveRepository _saveRepository;
  final SelectionRepository _selectionRepository;
  final SoundRepository _soundRepository;
  final StationRepository _stationRepository;
  final SunSpotRepository _sunSpotRepository;
  final WorkbenchRepository _workbenchRepository;

  const StartLevelUseCase({
    required this._carryOverRepository,
    required this._characterRepository,
    required this._campfireRepository,
    required this._compostRepository,
    required this._clockRepository,
    required this._constructionRepository,
    required this._dayRepository,
    required this._fireRepository,
    required this._fridgeRepository,
    required this._inventoryRepository,
    required this._locationRepository,
    required this._materialRepository,
    required this._pickupRepository,
    required this._mealRepository,
    required this._playerRepository,
    required this._pollutionRepository,
    required this._saveRepository,
    required this._selectionRepository,
    required this._soundRepository,
    required this._stationRepository,
    required this._sunSpotRepository,
    required this._workbenchRepository,
  });

  void call(GameLevel level) {
    _characterRepository.setMood(.normal);
    _selectionRepository.reset();
    _fireRepository.reset();
    _workbenchRepository.reset();
    _clockRepository.setPaused(false);
    final save = _saveRepository.takeLoadedSave();
    if (save != null && save.level == level) {
      _restore(save);
    } else {
      _reset(level);
    }
    _soundRepository.loop(.backgroundMusic);
  }

  void _restore(GameSave save) {
    _dayRepository.restore(save.day);
    _playerRepository.setStats(save.stats);
    _materialRepository.restore(save.materials);
    _pollutionRepository.restore(save.pollution);
    _inventoryRepository.restore(save.inventory);
    _pickupRepository.restore(save.pickups);
    _constructionRepository.restore(save.constructions);
    _stationRepository.restore(save.stations);
    _sunSpotRepository.restore(save.sunBottle);
    _campfireRepository.restore(save.campfireUses);
    _compostRepository.restore(save.compostPit);
    _fridgeRepository.restore(save.fridge);
    _mealRepository.restore(save.meals);
    _locationRepository.setLocation(save.location);
  }

  void _reset(GameLevel level) {
    final carryOver = _carryOverRepository.carryOver(level);
    _dayRepository.reset();
    _playerRepository.reset();
    _materialRepository.reset();
    _pollutionRepository.reset();
    _inventoryRepository.restore(carryOver.inventory.map(_fresh).toList());
    _pickupRepository.startLevel(level);
    _constructionRepository.restore(carryOver.constructions);
    _stationRepository.restore(carryOver.stations);
    _fridgeRepository.restore(
      carryOver.fridge.copyWith(
        slots: [
          for (final stack in carryOver.fridge.slots)
            if (stack == null) null else _fresh(stack),
        ],
      ),
    );
    _sunSpotRepository.reset();
    _campfireRepository.reset();
    _compostRepository.reset();
    _mealRepository.reset();
    _locationRepository.setLocation(.house);
  }

  static InventoryStack _fresh(InventoryStack stack) => stack.isSpoiled ? stack : stack.copyWith(age: 0);
}
