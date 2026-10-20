import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'level_3_event.dart';
part 'level_3_state.dart';

class Level3Bloc extends Bloc<Level3Event, Level3State> {
  static const _level = GameLevel.level3;

  final StartLevelUseCase _startLevelUseCase;

  Level3Bloc() : _startLevelUseCase = diContainer.get(), super(const Level3State()) {
    on<Level3Started>((event, emit) => _startLevelUseCase(_level));
  }
}
