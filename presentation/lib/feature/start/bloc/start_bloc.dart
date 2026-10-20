import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'start_event.dart';
part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final AppRepository _appRepository;
  final CharacterRepository _characterRepository;
  final ProgressRepository _progressRepository;

  StartBloc()
    : _appRepository = diContainer.get(),
      _characterRepository = diContainer.get(),
      _progressRepository = diContainer.get(),
      super(StartState(unlockedLevel: diContainer.get<ProgressRepository>().unlockedLevel)) {
    on<StartStarted>((event, emit) => _characterRepository.setMood(.normal));
    on<StartNewGameTapped>(_onNewGameTapped);
    on<StartExitTapped>((event, emit) => _appRepository.exit());
    on<StartBackTapped>(_onBackTapped);
  }

  void _onNewGameTapped(StartNewGameTapped event, Emitter<StartState> emit) {
    _progressRepository.reset();
    emit(state.copyWith(isLevelSelection: true, unlockedLevel: _progressRepository.unlockedLevel));
  }

  void _onBackTapped(StartBackTapped event, Emitter<StartState> emit) =>
      emit(state.copyWith(isLevelSelection: false, unlockedLevel: _progressRepository.unlockedLevel));
}
