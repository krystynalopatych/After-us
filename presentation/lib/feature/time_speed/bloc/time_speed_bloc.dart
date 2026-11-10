import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/time_speed/repository/time_speed_repository.dart';
import 'package:domain/time_speed/use_case/set_time_speed_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'time_speed_event.dart';
part 'time_speed_state.dart';

class TimeSpeedBloc extends Bloc<TimeSpeedEvent, TimeSpeedState> {
  final DayRepository _dayRepository;
  final SetTimeSpeedUseCase _setTimeSpeedUseCase;
  final TimeSpeedRepository _timeSpeedRepository;

  TimeSpeedBloc()
    : _dayRepository = diContainer.get(),
      _setTimeSpeedUseCase = diContainer.get(),
      _timeSpeedRepository = diContainer.get(),
      super(const TimeSpeedState()) {
    on<TimeSpeedStarted>(_onStarted);
    on<TimeSpeedToggled>((event, emit) => _setTimeSpeedUseCase(!state.isFast));
  }

  Future<void> _onStarted(
    TimeSpeedStarted event,
    Emitter<TimeSpeedState> emit,
  ) {
    _setTimeSpeedUseCase(false);
    emit(TimeSpeedState(isNight: _dayRepository.day.isNight));
    return Future.wait([
      emit.forEach(
        _timeSpeedRepository.isFastStream,
        onData: (isFast) => state.copyWith(isFast: isFast),
      ),
      emit.forEach(
        _dayRepository.dayStream,
        onData: (day) {
          if (day.isNight) {
            _setTimeSpeedUseCase(false);
          }
          return state.copyWith(isNight: day.isNight);
        },
      ),
    ]);
  }
}
