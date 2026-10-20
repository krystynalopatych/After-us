import 'package:domain/station/model/station.dart';
import 'package:domain/station/model/station_choice.dart';
import 'package:domain/station/use_case/build_station_use_case.dart';
import 'package:domain/station/use_case/station_choices_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'station_build_event.dart';
part 'station_build_state.dart';

class StationBuildBloc extends Bloc<StationBuildEvent, StationBuildState> {
  final BuildStationUseCase _buildStationUseCase;
  final StationChoicesUseCase _stationChoicesUseCase;

  StationBuildBloc()
    : _buildStationUseCase = diContainer.get(),
      _stationChoicesUseCase = diContainer.get(),
      super(const StationBuildState()) {
    on<StationBuildStarted>((event, emit) => emit(state.copyWith(choices: _stationChoicesUseCase())));
    on<StationBuildTapped>((event, emit) => _buildStationUseCase(event.station));
  }
}
