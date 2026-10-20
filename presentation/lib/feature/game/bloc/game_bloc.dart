import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/location/use_case/travel_use_case.dart';
import 'package:domain/station/use_case/station_choices_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final FillBottleUseCase _fillBottleUseCase;
  final LocationRepository _locationRepository;
  final StationChoicesUseCase _stationChoicesUseCase;
  final TravelUseCase _travelUseCase;

  GameBloc()
    : _fillBottleUseCase = diContainer.get(),
      _locationRepository = diContainer.get(),
      _stationChoicesUseCase = diContainer.get(),
      _travelUseCase = diContainer.get(),
      super(GameState(location: diContainer.get<LocationRepository>().location)) {
    on<GameStarted>(_onStarted);
    on<GameMapTapped>((event, emit) => emit(state.copyWith(isMapOpen: true)));
    on<GameMapClosed>((event, emit) => emit(state.copyWith(isMapOpen: false)));
    on<GameLocationSelected>(_onLocationSelected);
    on<GameLakeWaterTapped>((event, emit) => _fillBottleUseCase());
    on<GameLocationTapped>((event, emit) => emit(state.copyWith(isBuildOpen: _stationChoicesUseCase().isNotEmpty)));
    on<GameBuildClosed>((event, emit) => emit(state.copyWith(isBuildOpen: false)));
  }

  Future<void> _onStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(location: _locationRepository.location));
    return emit.forEach(
      _locationRepository.locationStream,
      onData: (location) => state.copyWith(location: location),
    );
  }

  void _onLocationSelected(
    GameLocationSelected event,
    Emitter<GameState> emit,
  ) {
    _travelUseCase(event.location);
    emit(
      state.copyWith(
        location: _locationRepository.location,
        isMapOpen: false,
      ),
    );
  }
}
