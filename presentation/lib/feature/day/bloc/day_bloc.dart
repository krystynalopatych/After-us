import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/day/repository/ticker_repository.dart';
import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'day_event.dart';
part 'day_state.dart';

class DayBloc extends Bloc<DayEvent, DayState> {
  final DayRepository _dayRepository;
  final TickerRepository _tickerRepository;
  final PassSecondUseCase _passSecondUseCase;

  DayBloc()
    : _dayRepository = diContainer.get(),
      _tickerRepository = diContainer.get(),
      _passSecondUseCase = diContainer.get(),
      super(DayState(day: diContainer.get<DayRepository>().day)) {
    on<DayStarted>(_onStarted);
  }

  Future<void> _onStarted(
    DayStarted event,
    Emitter<DayState> emit,
  ) {
    emit(
      state.copyWith(
        day: _dayRepository.day,
        levelDays: event.level.days,
      ),
    );
    return Future.wait([
      emit.forEach(
        _dayRepository.dayStream,
        onData: (day) => state.copyWith(day: day),
      ),
      emit.forEach(
        _tickerRepository.seconds,
        onData: (_) {
          _passSecondUseCase(event.level);
          return state;
        },
      ),
    ]);
  }
}
