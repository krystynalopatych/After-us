import 'package:domain/mushroom/model/mushroom_farm.dart';
import 'package:domain/mushroom/repository/mushroom_farm_repository.dart';
import 'package:domain/mushroom/use_case/use_mushroom_farm_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'mushroom_event.dart';
part 'mushroom_state.dart';

class MushroomBloc extends Bloc<MushroomEvent, MushroomState> {
  final MushroomFarmRepository _mushroomFarmRepository;
  final UseMushroomFarmUseCase _useMushroomFarmUseCase;

  MushroomBloc()
    : _mushroomFarmRepository = diContainer.get(),
      _useMushroomFarmUseCase = diContainer.get(),
      super(MushroomState(farm: diContainer.get<MushroomFarmRepository>().farm)) {
    on<MushroomStarted>(_onStarted);
    on<MushroomFarmTapped>((event, emit) => _useMushroomFarmUseCase());
  }

  Future<void> _onStarted(
    MushroomStarted event,
    Emitter<MushroomState> emit,
  ) {
    emit(state.copyWith(farm: _mushroomFarmRepository.farm));
    return emit.forEach(
      _mushroomFarmRepository.farmStream,
      onData: (farm) => state.copyWith(farm: farm),
    );
  }
}
