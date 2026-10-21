import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';
import 'package:domain/sun_spot/use_case/use_sun_spot_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'sun_spot_event.dart';
part 'sun_spot_state.dart';

class SunSpotBloc extends Bloc<SunSpotEvent, SunSpotState> {
  final SunSpotRepository _sunSpotRepository;
  final UseSunSpotUseCase _useSunSpotUseCase;

  SunSpotBloc()
    : _sunSpotRepository = diContainer.get(),
      _useSunSpotUseCase = diContainer.get(),
      super(SunSpotState(bottle: diContainer.get<SunSpotRepository>().bottle)) {
    on<SunSpotStarted>(_onStarted);
    on<SunSpotTapped>((event, emit) => _useSunSpotUseCase());
  }

  Future<void> _onStarted(
    SunSpotStarted event,
    Emitter<SunSpotState> emit,
  ) {
    emit(state.copyWith(bottle: () => _sunSpotRepository.bottle));
    return emit.forEach(
      _sunSpotRepository.bottleStream,
      onData: (bottle) => state.copyWith(bottle: () => bottle),
    );
  }
}
