import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'level_3_event.dart';
part 'level_3_state.dart';

class Level3Bloc extends Bloc<Level3Event, Level3State> {
  static const _level = GameLevel.level3;

  final CharacterRepository _characterRepository;
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;
  final SaveRepository _saveRepository;

  Level3Bloc()
    : _characterRepository = diContainer.get(),
      _inventoryRepository = diContainer.get(),
      _locationRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _pickupRepository = diContainer.get(),
      _playerRepository = diContainer.get(),
      _pollutionRepository = diContainer.get(),
      _saveRepository = diContainer.get(),
      super(const Level3State()) {
    on<Level3Started>(_onStarted);
  }

  void _onStarted(Level3Started event, Emitter<Level3State> emit) {
    _characterRepository.setMood(.normal);
    final save = _saveRepository.takeLoadedSave();
    if (save != null && save.level == _level) {
      _restore(save);
    } else {
      _reset();
    }
  }

  void _restore(GameSave save) {
    _playerRepository.setStats(save.stats);
    _materialRepository.restore(save.materials);
    _pollutionRepository.restore(save.pollution);
    _inventoryRepository.restore(save.inventory);
    _pickupRepository.restore(save.pickups);
    _locationRepository.setLocation(save.location);
  }

  void _reset() {
    _playerRepository.reset();
    _materialRepository.reset();
    _pollutionRepository.reset();
    _inventoryRepository.reset();
    _pickupRepository.startLevel(_level);
    _locationRepository.setLocation(.house);
  }
}
