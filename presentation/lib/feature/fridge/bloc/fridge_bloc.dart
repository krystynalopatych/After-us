import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/fridge/use_case/fridge_cooling_use_case.dart';
import 'package:domain/fridge/use_case/fridge_slot_use_case.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'fridge_event.dart';
part 'fridge_state.dart';

class FridgeBloc extends Bloc<FridgeEvent, FridgeState> {
  final FridgeCoolingUseCase _fridgeCoolingUseCase;
  final FridgeRepository _fridgeRepository;
  final FridgeSlotUseCase _fridgeSlotUseCase;

  FridgeBloc()
    : _fridgeCoolingUseCase = diContainer.get(),
      _fridgeRepository = diContainer.get(),
      _fridgeSlotUseCase = diContainer.get(),
      super(const FridgeState()) {
    on<FridgeStarted>(_onStarted);
    on<FridgeSlotTapped>((event, emit) => _fridgeSlotUseCase(event.index));
  }

  Future<void> _onStarted(
    FridgeStarted event,
    Emitter<FridgeState> emit,
  ) {
    emit(
      FridgeState(
        slots: _fridgeRepository.fridge.slots,
        isCooling: _fridgeCoolingUseCase.isCooling,
      ),
    );
    return Future.wait([
      emit.forEach(
        _fridgeRepository.fridgeStream,
        onData: (fridge) => state.copyWith(slots: fridge.slots),
      ),
      emit.forEach(
        _fridgeCoolingUseCase.isCoolingStream,
        onData: (isCooling) => state.copyWith(isCooling: isCooling),
      ),
    ]);
  }
}
