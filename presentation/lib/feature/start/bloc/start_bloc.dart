import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'start_event.dart';
part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  final AppRepository _appRepository;
  final CharacterRepository _characterRepository;
  final ProgressRepository _progressRepository;

  StartBloc(this._appRepository, this._characterRepository, this._progressRepository)
    : super(StartState(unlockedLevel: _progressRepository.unlockedLevel)) {
    on<StartStarted>((event, emit) => _characterRepository.setMood(.normal));
    on<StartNewGameTapped>(_onNewGameTapped);
    on<StartExitTapped>((event, emit) => _appRepository.exit());
    on<StartBackTapped>((event, emit) => emit(StartState(unlockedLevel: _progressRepository.unlockedLevel)));
  }

  void _onNewGameTapped(StartNewGameTapped event, Emitter<StartState> emit) {
    _progressRepository.reset();
    emit(
      StartState(
        isLevelSelection: true,
        unlockedLevel: _progressRepository.unlockedLevel,
      ),
    );
  }
}
