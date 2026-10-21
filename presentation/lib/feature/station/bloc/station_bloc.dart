import 'package:domain/station/model/station.dart';
import 'package:domain/station/repository/station_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'station_event.dart';
part 'station_state.dart';

class StationBloc extends Bloc<StationEvent, StationState> {
  final StationRepository _stationRepository;

  StationBloc()
    : _stationRepository = diContainer.get(),
      super(StationState(built: diContainer.get<StationRepository>().built)) {
    on<StationStarted>(_onStarted);
  }

  Future<void> _onStarted(
    StationStarted event,
    Emitter<StationState> emit,
  ) {
    emit(state.copyWith(built: _stationRepository.built));
    return emit.forEach(
      _stationRepository.builtStream,
      onData: (built) => state.copyWith(built: built),
    );
  }
}
