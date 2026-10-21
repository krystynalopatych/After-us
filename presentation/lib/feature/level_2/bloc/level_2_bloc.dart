import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'level_2_event.dart';
part 'level_2_state.dart';

class Level2Bloc extends Bloc<Level2Event, Level2State> {
  static const _level = GameLevel.level2;

  final StartLevelUseCase _startLevelUseCase;

  Level2Bloc() : _startLevelUseCase = diContainer.get(), super(const Level2State()) {
    on<Level2Started>(_onStarted);
    on<Level2Retried>(_onStarted);
  }

  void _onStarted(
    Level2Event event,
    Emitter<Level2State> emit,
  ) {
    _startLevelUseCase(_level);
    emit(state.copyWith(run: state.run + 1));
  }
}
