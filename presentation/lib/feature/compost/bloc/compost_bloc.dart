import 'package:domain/compost/model/compost_pit.dart';
import 'package:domain/compost/repository/compost_repository.dart';
import 'package:domain/compost/use_case/use_compost_pit_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'compost_event.dart';
part 'compost_state.dart';

class CompostBloc extends Bloc<CompostEvent, CompostState> {
  final CompostRepository _compostRepository;
  final UseCompostPitUseCase _useCompostPitUseCase;

  CompostBloc()
    : _compostRepository = diContainer.get(),
      _useCompostPitUseCase = diContainer.get(),
      super(CompostState(pit: diContainer.get<CompostRepository>().pit)) {
    on<CompostStarted>(_onStarted);
    on<CompostPitTapped>((event, emit) => _useCompostPitUseCase());
  }

  Future<void> _onStarted(
    CompostStarted event,
    Emitter<CompostState> emit,
  ) {
    emit(state.copyWith(pit: _compostRepository.pit));
    return emit.forEach(
      _compostRepository.pitStream,
      onData: (pit) => state.copyWith(pit: pit),
    );
  }
}
