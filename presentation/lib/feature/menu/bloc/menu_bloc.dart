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

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;
  final SaveRepository _saveRepository;

  MenuBloc()
    : _inventoryRepository = diContainer.get(),
      _locationRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _pickupRepository = diContainer.get(),
      _playerRepository = diContainer.get(),
      _pollutionRepository = diContainer.get(),
      _saveRepository = diContainer.get(),
      super(const MenuState()) {
    on<MenuStarted>((event, emit) => emit(const MenuState()));
    on<MenuToggled>((event, emit) => emit(MenuState(isOpen: !state.isOpen)));
    on<MenuClosed>((event, emit) => emit(const MenuState()));
    on<MenuSaveTapped>(_onSaveTapped);
  }

  void _onSaveTapped(MenuSaveTapped event, Emitter<MenuState> emit) {
    _saveRepository.addSave(
      GameSave(
        level: event.level,
        location: _locationRepository.location,
        savedAt: DateTime.now(),
        stats: _playerRepository.stats,
        materials: _materialRepository.stocks,
        inventory: _inventoryRepository.stacks,
        pickups: _pickupRepository.pickups,
        pollution: _pollutionRepository.pollution,
      ),
    );
    emit(const MenuState(isOpen: true, isSaved: true));
  }
}
