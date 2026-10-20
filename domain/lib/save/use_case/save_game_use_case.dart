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
import 'package:domain/station/repository/station_repository.dart';

final class SaveGameUseCase {
  final ConstructionRepository _constructionRepository;
  final DayRepository _dayRepository;
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;
  final SaveRepository _saveRepository;
  final StationRepository _stationRepository;

  const SaveGameUseCase({
    required this._constructionRepository,
    required this._dayRepository,
    required this._inventoryRepository,
    required this._locationRepository,
    required this._materialRepository,
    required this._pickupRepository,
    required this._playerRepository,
    required this._pollutionRepository,
    required this._saveRepository,
    required this._stationRepository,
  });

  void call(GameLevel level) => _saveRepository.addSave(
    GameSave(
      level: level,
      location: _locationRepository.location,
      savedAt: DateTime.now(),
      day: _dayRepository.day,
      stats: _playerRepository.stats,
      materials: _materialRepository.stocks,
      inventory: _inventoryRepository.stacks,
      pickups: _pickupRepository.pickups,
      pollution: _pollutionRepository.pollution,
      constructions: _constructionRepository.built,
      stations: _stationRepository.built,
    ),
  );
}
