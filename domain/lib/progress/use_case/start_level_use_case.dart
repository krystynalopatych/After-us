import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';

final class StartLevelUseCase {
  final CharacterRepository _characterRepository;
  final ConstructionRepository _constructionRepository;
  final DayRepository _dayRepository;
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;
  final SaveRepository _saveRepository;

  const StartLevelUseCase({
    required this._characterRepository,
    required this._constructionRepository,
    required this._dayRepository,
    required this._inventoryRepository,
    required this._locationRepository,
    required this._materialRepository,
    required this._pickupRepository,
    required this._playerRepository,
    required this._pollutionRepository,
    required this._saveRepository,
  });

  void call(GameLevel level) {
    _characterRepository.setMood(.normal);
    final save = _saveRepository.takeLoadedSave();
    if (save != null && save.level == level) {
      _restore(save);
    } else {
      _reset(level);
    }
  }

  void _restore(GameSave save) {
    _dayRepository.restore(save.day);
    _playerRepository.setStats(save.stats);
    _materialRepository.restore(save.materials);
    _pollutionRepository.restore(save.pollution);
    _inventoryRepository.restore(save.inventory);
    _pickupRepository.restore(save.pickups);
    _constructionRepository.restore(save.constructions);
    _locationRepository.setLocation(save.location);
  }

  void _reset(GameLevel level) {
    _dayRepository.reset();
    _playerRepository.reset();
    _materialRepository.reset();
    _pollutionRepository.reset();
    _inventoryRepository.reset();
    _pickupRepository.startLevel(level);
    _constructionRepository.reset();
    _locationRepository.setLocation(.house);
  }
}
