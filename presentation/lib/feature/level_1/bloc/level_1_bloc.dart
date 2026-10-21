import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'level_1_event.dart';
part 'level_1_state.dart';

class Level1Bloc extends Bloc<Level1Event, Level1State> {
  static const _level = GameLevel.level1;

  final StartLevelUseCase _startLevelUseCase;

  Level1Bloc() : _startLevelUseCase = diContainer.get(), super(const Level1State()) {
    on<Level1Started>(_onStarted);
  }

  void _onStarted(
    Level1Started event,
    Emitter<Level1State> emit,
  ) {
    _startLevelUseCase(_level);
    emit(state.copyWith(isStarted: true));
  }
}
