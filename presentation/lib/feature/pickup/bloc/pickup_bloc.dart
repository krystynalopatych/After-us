import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'pickup_event.dart';
part 'pickup_state.dart';

class PickupBloc extends Bloc<PickupEvent, PickupState> {
  final InventoryRepository _inventoryRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PickupRepository _pickupRepository;

  PickupBloc()
    : _inventoryRepository = diContainer.get(),
      _locationRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _pickupRepository = diContainer.get(),
      super(const PickupState()) {
    on<PickupStarted>(_onStarted);
    on<PickupTapped>(_onTapped);
  }

  Future<void> _onStarted(PickupStarted event, Emitter<PickupState> emit) {
    emit(_toState(_locationRepository.location, _pickupRepository.pickups));
    return Future.wait([
      emit.forEach(
        _locationRepository.locationStream,
        onData: (location) => _toState(location, _pickupRepository.pickups),
      ),
      emit.forEach(
        _pickupRepository.pickupsStream,
        onData: (pickups) => _toState(_locationRepository.location, pickups),
      ),
    ]);
  }

  void _onTapped(PickupTapped event, Emitter<PickupState> emit) {
    final kind = event.pickup.kind;
    if (kind.material case final material?) {
      _materialRepository.add(material);
    } else if (kind.food case final food? when !_inventoryRepository.add(food)) {
      return;
    }
    _pickupRepository.collect(event.pickup);
  }

  static PickupState _toState(GameLocation location, List<Pickup> pickups) => PickupState(
    pickups: [
      for (final pickup in pickups)
        if (pickup.location == location) pickup,
    ],
  );
}
