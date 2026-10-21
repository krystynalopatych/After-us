import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/progress/use_case/new_game_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'start_event.dart';
part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final AppRepository _appRepository;
  final CharacterRepository _characterRepository;
  final NewGameUseCase _newGameUseCase;
  final ProgressRepository _progressRepository;

  StartBloc()
    : _appRepository = diContainer.get(),
      _characterRepository = diContainer.get(),
      _newGameUseCase = diContainer.get(),
      _progressRepository = diContainer.get(),
      super(StartState(unlockedLevel: diContainer.get<ProgressRepository>().unlockedLevel)) {
    on<StartStarted>(_onStarted);
    on<StartNewGameTapped>(_onNewGameTapped);
    on<StartExitTapped>((event, emit) => _appRepository.exit());
    on<StartBackTapped>(_onBackTapped);
  }

  void _onStarted(
    StartStarted event,
    Emitter<StartState> emit,
  ) {
    _characterRepository.setMood(.normal);
    emit(
      state.copyWith(
        isLevelSelection: event.isLevelSelection,
        unlockedLevel: _progressRepository.unlockedLevel,
      ),
    );
  }

  void _onNewGameTapped(
    StartNewGameTapped event,
    Emitter<StartState> emit,
  ) {
    _newGameUseCase();
    emit(
      state.copyWith(
        isLevelSelection: true,
        unlockedLevel: _progressRepository.unlockedLevel,
      ),
    );
  }

  void _onBackTapped(
    StartBackTapped event,
    Emitter<StartState> emit,
  ) => emit(
    state.copyWith(
      isLevelSelection: false,
      unlockedLevel: _progressRepository.unlockedLevel,
    ),
  );
}
