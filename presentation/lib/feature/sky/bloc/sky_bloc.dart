import 'package:domain/air/model/air_quality.dart';
import 'package:domain/air/repository/air_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/src/widget/sky/model/sky_state.dart';
import 'package:presentation/di/di_container.dart';

part 'sky_event.dart';

class SkyBloc extends Bloc<SkyEvent, SkyState> {
  final AirRepository _airRepository;

  SkyBloc()
    : _airRepository = diContainer.get(),
      super(_toState(diContainer.get<AirRepository>().quality)) {
    on<SkyStarted>(_onStarted);
  }

  Future<void> _onStarted(SkyStarted event, Emitter<SkyState> emit) {
    emit(_toState(_airRepository.quality));
    return emit.forEach(
      _airRepository.qualityStream,
      onData: _toState,
    );
  }

  static SkyState _toState(AirQuality quality) => switch (quality) {
    .clean => .clear,
    .smoky => .smoky,
    .polluted => .polluted,
  };
}
