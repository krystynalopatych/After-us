import 'package:domain/garden/model/garden_bed.dart';
import 'package:domain/garden/repository/garden_bed_repository.dart';
import 'package:domain/garden/use_case/use_garden_bed_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'garden_event.dart';
part 'garden_state.dart';

class GardenBloc extends Bloc<GardenEvent, GardenState> {
  final GardenBedRepository _gardenBedRepository;
  final UseGardenBedUseCase _useGardenBedUseCase;

  GardenBloc()
    : _gardenBedRepository = diContainer.get(),
      _useGardenBedUseCase = diContainer.get(),
      super(GardenState(bed: diContainer.get<GardenBedRepository>().bed)) {
    on<GardenStarted>(_onStarted);
    on<GardenBedTapped>((event, emit) => _useGardenBedUseCase());
  }

  Future<void> _onStarted(
    GardenStarted event,
    Emitter<GardenState> emit,
  ) {
    emit(state.copyWith(bed: _gardenBedRepository.bed));
    return emit.forEach(
      _gardenBedRepository.bedStream,
      onData: (bed) => state.copyWith(bed: bed),
    );
  }
}
