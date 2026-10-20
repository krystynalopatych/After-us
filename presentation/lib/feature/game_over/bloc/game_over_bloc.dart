import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/model/level_result.dart';
import 'package:domain/progress/use_case/level_result_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'game_over_event.dart';
part 'game_over_state.dart';

class GameOverBloc extends Bloc<GameOverEvent, GameOverState> {
  final GameLevel _level;
  final LevelResultUseCase _levelResultUseCase;
  final StartLevelUseCase _startLevelUseCase;

  GameOverBloc({required this._level})
    : _levelResultUseCase = diContainer.get(),
      _startLevelUseCase = diContainer.get(),
      super(const GameOverState()) {
    on<GameOverStarted>(_onStarted);
    on<GameOverRetryTapped>((event, emit) => _startLevelUseCase(_level));
  }

  Future<void> _onStarted(
    GameOverStarted event,
    Emitter<GameOverState> emit,
  ) {
    emit(state.copyWith(result: () => _levelResultUseCase.result(_level)));
    return emit.forEach(
      _levelResultUseCase.resultStream(_level),
      onData: (result) => state.copyWith(result: () => result),
    );
  }
}
