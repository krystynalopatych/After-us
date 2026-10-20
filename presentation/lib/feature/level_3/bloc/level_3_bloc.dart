import 'package:domain/air/repository/air_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'level_3_event.dart';
part 'level_3_state.dart';

class Level3Bloc extends Bloc<Level3Event, Level3State> {
  final AirRepository _airRepository;
  final CharacterRepository _characterRepository;
  final LocationRepository _locationRepository;
  final MaterialRepository _materialRepository;
  final PlayerRepository _playerRepository;

  Level3Bloc()
    : _airRepository = diContainer.get(),
      _characterRepository = diContainer.get(),
      _locationRepository = diContainer.get(),
      _materialRepository = diContainer.get(),
      _playerRepository = diContainer.get(),
      super(const Level3State()) {
    on<Level3Started>(_onStarted);
  }

  void _onStarted(Level3Started event, Emitter<Level3State> emit) {
    _characterRepository.setMood(.normal);
    _playerRepository.reset();
    _materialRepository.reset();
    _airRepository.reset();
    _locationRepository.setLocation(.house);
  }
}
