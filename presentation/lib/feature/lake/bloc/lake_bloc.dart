import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'lake_event.dart';
part 'lake_state.dart';

class LakeBloc extends Bloc<LakeEvent, LakeState> {
  final PollutionRepository _pollutionRepository;

  LakeBloc()
    : _pollutionRepository = diContainer.get(),
      super(LakeState(isPolluted: diContainer.get<PollutionRepository>().pollution.isWaterPolluted)) {
    on<LakeStarted>(_onStarted);
  }

  Future<void> _onStarted(
    LakeStarted event,
    Emitter<LakeState> emit,
  ) {
    emit(state.copyWith(isPolluted: _pollutionRepository.pollution.isWaterPolluted));
    return emit.forEach(
      _pollutionRepository.pollutionStream,
      onData: (pollution) => state.copyWith(isPolluted: pollution.isWaterPolluted),
    );
  }
}
