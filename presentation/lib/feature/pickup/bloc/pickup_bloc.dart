import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'pickup_event.dart';
part 'pickup_state.dart';

class PickupBloc extends Bloc<PickupEvent, PickupState> {
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;
  final PollutionRepository _pollutionRepository;

  PickupBloc()
    : _inventoryRepository = diContainer.get(),
      _locationRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _pickupRepository = diContainer.get(),
      _pollutionRepository = diContainer.get(),
      super(const PickupState()) {
    on<PickupStarted>(_onStarted);
    on<PickupTapped>((event, emit) => emit(_withFound(event.pickup, .choice)));
    on<PickupKeepTapped>(_onKeepTapped);
    on<PickupThrowTapped>((event, emit) => emit(_withFound(state.found, .throwTarget)));
    on<PickupThrowTargetTapped>(_onThrowTargetTapped);
    on<PickupDismissed>((event, emit) => emit(_withFound(null, .choice)));
  }

  Future<void> _onStarted(PickupStarted event, Emitter<PickupState> emit) {
    emit(_withPickups(_locationRepository.location, _pickupRepository.pickups));
    return Future.wait([
      emit.forEach(
        _locationRepository.locationStream,
        onData: (location) => _withPickups(location, _pickupRepository.pickups),
      ),
      emit.forEach(
        _pickupRepository.pickupsStream,
        onData: (pickups) => _withPickups(_locationRepository.location, pickups),
      ),
    ]);
  }

  void _onKeepTapped(PickupKeepTapped event, Emitter<PickupState> emit) {
    final pickup = state.found;
    if (pickup == null) {
      return;
    }
    if (pickup.kind.material case final material?) {
      _materialRepository.add(material);
    } else if (pickup.kind.food case final food? when !_inventoryRepository.add(food)) {
      emit(_withFound(pickup, .inventoryFull));
      return;
    }
    emit(_withFound(null, .choice));
    _pickupRepository.collect(pickup);
  }

  void _onThrowTargetTapped(PickupThrowTargetTapped event, Emitter<PickupState> emit) {
    final pickup = state.found;
    if (pickup == null) {
      return;
    }
    if (pickup.kind.material case final material?) {
      switch (event.target) {
        case .lake:
          _pollutionRepository.polluteWater();
        case .forest:
          _pollutionRepository.polluteSoil();
        case .dump || .house || .store || .garage:
          _pollutionRepository.addAirPoints(material.airPoints);
      }
    }
    emit(_withFound(null, .choice));
    _pickupRepository.collect(pickup);
  }

  PickupState _withFound(Pickup? found, PickupStep step) => PickupState(
    pickups: state.pickups,
    found: found,
    step: step,
  );

  PickupState _withPickups(GameLocation location, List<Pickup> pickups) => PickupState(
    pickups: [
      for (final pickup in pickups)
        if (pickup.location == location) pickup,
    ],
    found: state.found,
    step: state.step,
  );
}
