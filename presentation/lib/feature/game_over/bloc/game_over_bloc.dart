import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'game_over_event.dart';
part 'game_over_state.dart';

class GameOverBloc extends Bloc<GameOverEvent, GameOverState> {
  final DayRepository _dayRepository;

  GameOverBloc()
    : _dayRepository = diContainer.get(),
      super(GameOverState(outcome: diContainer.get<DayRepository>().outcome)) {
    on<GameOverStarted>(_onStarted);
  }

  Future<void> _onStarted(
    GameOverStarted event,
    Emitter<GameOverState> emit,
  ) {
    emit(state.copyWith(outcome: () => _dayRepository.outcome));
    return emit.forEach(
      _dayRepository.outcomeStream,
      onData: (outcome) => state.copyWith(outcome: () => outcome),
    );
  }
}
