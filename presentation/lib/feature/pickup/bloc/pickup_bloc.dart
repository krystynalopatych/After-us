import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/use_case/keep_pickup_use_case.dart';
import 'package:domain/pickup/use_case/location_pickups_use_case.dart';
import 'package:domain/pickup/use_case/throw_pickup_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'pickup_event.dart';
part 'pickup_state.dart';

class PickupBloc extends Bloc<PickupEvent, PickupState> {
  final KeepPickupUseCase _keepPickupUseCase;
  final LocationPickupsUseCase _locationPickupsUseCase;
  final ThrowPickupUseCase _throwPickupUseCase;

  PickupBloc()
    : _keepPickupUseCase = diContainer.get(),
      _locationPickupsUseCase = diContainer.get(),
      _throwPickupUseCase = diContainer.get(),
      super(PickupState(pickups: diContainer.get<LocationPickupsUseCase>().pickups)) {
    on<PickupStarted>(_onStarted);
    on<PickupTapped>(
      (event, emit) => emit(
        state.copyWith(
          found: () => event.pickup,
          step: .choice,
        ),
      ),
    );
    on<PickupKeepTapped>(_onKeepTapped);
    on<PickupThrowTapped>((event, emit) => emit(state.copyWith(step: .throwTarget)));
    on<PickupThrowTargetTapped>(_onThrowTargetTapped);
    on<PickupDismissed>(
      (event, emit) => emit(
        state.copyWith(
          found: () => null,
          step: .choice,
        ),
      ),
    );
  }

  Future<void> _onStarted(
    PickupStarted event,
    Emitter<PickupState> emit,
  ) {
    emit(state.copyWith(pickups: _locationPickupsUseCase.pickups));
    return emit.forEach(
      _locationPickupsUseCase.pickupsStream,
      onData: (pickups) => state.copyWith(pickups: pickups),
    );
  }

  void _onKeepTapped(
    PickupKeepTapped event,
    Emitter<PickupState> emit,
  ) {
    final pickup = state.found;
    if (pickup == null) {
      return;
    }
    if (_keepPickupUseCase(pickup)) {
      emit(
        state.copyWith(
          found: () => null,
          step: .choice,
        ),
      );
    } else {
      emit(state.copyWith(step: .inventoryFull));
    }
  }

  void _onThrowTargetTapped(
    PickupThrowTargetTapped event,
    Emitter<PickupState> emit,
  ) {
    final pickup = state.found;
    if (pickup == null) {
      return;
    }
    emit(
      state.copyWith(
        found: () => null,
        step: .choice,
      ),
    );
    _throwPickupUseCase(
      pickup,
      event.target,
    );
  }
}
