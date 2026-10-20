import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'level_2_event.dart';
part 'level_2_state.dart';

class Level2Bloc extends Bloc<Level2Event, Level2State> {
  final CharacterRepository _characterRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PlayerRepository _playerRepository;

  Level2Bloc()
    : _characterRepository = diContainer.get(),
      _locationRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _playerRepository = diContainer.get(),
      super(const Level2State()) {
    on<Level2Started>(_onStarted);
  }

  void _onStarted(Level2Started event, Emitter<Level2State> emit) {
    _characterRepository.setMood(.normal);
    _playerRepository.reset();
    _materialRepository.reset();
    _locationRepository.setLocation(.house);
  }
}
