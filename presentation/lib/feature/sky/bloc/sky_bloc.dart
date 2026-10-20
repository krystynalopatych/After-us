import 'package:domain/pollution/model/air_quality.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/src/widget/sky/model/sky_state.dart';
import 'package:presentation/di/di_container.dart';

part 'sky_event.dart';

class SkyBloc extends Bloc<SkyEvent, SkyState> {
  final PollutionRepository _pollutionRepository;

  SkyBloc()
    : _pollutionRepository = diContainer.get(),
      super(_toState(diContainer.get<PollutionRepository>().pollution.airQuality)) {
    on<SkyStarted>(_onStarted);
  }

  Future<void> _onStarted(SkyStarted event, Emitter<SkyState> emit) {
    emit(_toState(_pollutionRepository.pollution.airQuality));
    return emit.forEach(
      _pollutionRepository.pollutionStream,
      onData: (pollution) => _toState(pollution.airQuality),
    );
  }

  static SkyState _toState(AirQuality quality) => switch (quality) {
    .clean => .clear,
    .smoky => .smoky,
    .polluted => .polluted,
  };
}
