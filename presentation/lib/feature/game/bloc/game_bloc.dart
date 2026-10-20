import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final LocationRepository _locationRepository;

  GameBloc()
    : _locationRepository = diContainer.get(),
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
    _locationRepository.setLocation(event.location);
  }
}
