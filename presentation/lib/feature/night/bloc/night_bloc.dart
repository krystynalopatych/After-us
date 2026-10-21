import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'night_event.dart';
part 'night_state.dart';

class NightBloc extends Bloc<NightEvent, NightState> {
  final DayRepository _dayRepository;

  NightBloc()
    : _dayRepository = diContainer.get(),
      super(NightState(nightSeconds: diContainer.get<DayRepository>().day.nightSeconds)) {
    on<NightStarted>(_onStarted);
  }

  Future<void> _onStarted(
    NightStarted event,
    Emitter<NightState> emit,
  ) {
    emit(state.copyWith(nightSeconds: _dayRepository.day.nightSeconds));
    return emit.forEach(
      _dayRepository.dayStream,
      onData: (day) => state.copyWith(nightSeconds: day.nightSeconds),
    );
  }
}
