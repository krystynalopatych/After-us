import 'package:domain/air/repository/air_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'level_1_event.dart';
part 'level_1_state.dart';

class Level1Bloc extends Bloc<Level1Event, Level1State> {
  final AirRepository _airRepository;
  final CharacterRepository _characterRepository;
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;
  final PlayerRepository _playerRepository;

  Level1Bloc()
    : _airRepository = diContainer.get(),
      _characterRepository = diContainer.get(),
      _inventoryRepository = diContainer.get(),
      _locationRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _pickupRepository = diContainer.get(),
      _playerRepository = diContainer.get(),
      super(const Level1State()) {
    on<Level1Started>(_onStarted);
  }

  void _onStarted(Level1Started event, Emitter<Level1State> emit) {
    _characterRepository.setMood(.normal);
    _playerRepository.reset();
    _materialRepository.reset();
    _airRepository.reset();
    _inventoryRepository.reset();
    _pickupRepository.startLevel(GameLevel.level1);
    _locationRepository.setLocation(.house);
  }
}
