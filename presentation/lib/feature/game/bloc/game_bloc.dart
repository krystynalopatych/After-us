import 'dart:math';

import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  static const _farTripThirst = 10;

  final LocationRepository _locationRepository;
  final PlayerRepository _playerRepository;

  GameBloc()
    : _locationRepository = diContainer.get(),
      _playerRepository = diContainer.get(),
      super(GameState(location: diContainer.get<LocationRepository>().location)) {
    on<GameStarted>(_onStarted);
    on<GameMapTapped>((event, emit) => emit(GameState(location: state.location, isMapOpen: true)));
    on<GameMapClosed>((event, emit) => emit(GameState(location: state.location)));
    on<GameLocationSelected>(_onLocationSelected);
  }

  Future<void> _onStarted(GameStarted event, Emitter<GameState> emit) {
    emit(GameState(location: _locationRepository.location, isMapOpen: state.isMapOpen));
    return emit.forEach(
      _locationRepository.locationStream,
      onData: (location) => GameState(location: location, isMapOpen: state.isMapOpen),
    );
  }

  void _onLocationSelected(GameLocationSelected event, Emitter<GameState> emit) {
    emit(GameState(location: state.location));
    final from = _locationRepository.location;
    if (from != event.location && (from.isFar || event.location.isFar)) {
      final stats = _playerRepository.stats;
      _playerRepository.setStats(
        PlayerStats(
          health: stats.health,
          hunger: stats.hunger,
          thirst: max(0, stats.thirst - _farTripThirst),
        ),
      );
    }
    _locationRepository.setLocation(event.location);
  }
}
