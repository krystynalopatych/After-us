import 'package:domain/inventory/model/water_kind.dart';
import 'package:domain/inventory/model/water_request.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/inventory/use_case/lake_water_request_use_case.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/location/use_case/travel_use_case.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/use_case/place_station_use_case.dart';
import 'package:domain/station/use_case/station_choices_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final FillBottleUseCase _fillBottleUseCase;
  final LakeWaterRequestUseCase _lakeWaterRequestUseCase;
  final LocationRepository _locationRepository;
  final PlaceStationUseCase _placeStationUseCase;
  final StationChoicesUseCase _stationChoicesUseCase;
  final TravelUseCase _travelUseCase;

  GameBloc()
    : _fillBottleUseCase = diContainer.get(),
      _lakeWaterRequestUseCase = diContainer.get(),
      _locationRepository = diContainer.get(),
      _placeStationUseCase = diContainer.get(),
      _stationChoicesUseCase = diContainer.get(),
      _travelUseCase = diContainer.get(),
      super(GameState(location: diContainer.get<LocationRepository>().location)) {
    on<GameStarted>(_onStarted);
    on<GameMapTapped>((event, emit) => emit(state.copyWith(isMapOpen: true)));
    on<GameMapClosed>((event, emit) => emit(state.copyWith(isMapOpen: false)));
    on<GameLocationSelected>(_onLocationSelected);
    on<GameLakeWaterTapped>(_onLakeWaterTapped);
    on<GameWaterChoiceClosed>((event, emit) => emit(state.copyWith(waterChoice: () => null)));
    on<GameLocationTapped>(_onLocationTapped);
    on<GameBuildClosed>((event, emit) => emit(state.copyWith(isBuildOpen: false)));
    on<GameStationTapped>(_onStationTapped);
    on<GameFireClosed>((event, emit) => emit(state.copyWith(fireStation: () => null)));
    on<GameWorkbenchClosed>((event, emit) => emit(state.copyWith(isWorkbenchOpen: false)));
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

  void _onLocationTapped(
    GameLocationTapped event,
    Emitter<GameState> emit,
  ) {
    if (_placeStationUseCase()) {
      return;
    }
    emit(state.copyWith(isBuildOpen: _stationChoicesUseCase().isNotEmpty));
  }

  void _onLakeWaterTapped(
    GameLakeWaterTapped event,
    Emitter<GameState> emit,
  ) {
    switch (_lakeWaterRequestUseCase()) {
      case WaterRequest(:final water, :final bottle?):
        _fillBottleUseCase(
          bottle,
          water,
        );
      case WaterRequest(:final water):
        emit(state.copyWith(waterChoice: () => water));
      case null:
        return;
    }
  }

  void _onStationTapped(
    GameStationTapped event,
    Emitter<GameState> emit,
  ) => switch (event.station) {
    .campfire || .rocketStove => emit(state.copyWith(fireStation: () => event.station)),
    .workbench => emit(state.copyWith(isWorkbenchOpen: true)),
  };
}
