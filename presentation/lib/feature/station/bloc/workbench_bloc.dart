import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/workbench_slot_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'workbench_event.dart';
part 'workbench_state.dart';

class WorkbenchBloc extends Bloc<WorkbenchEvent, WorkbenchState> {
  final CraftUseCase _craftUseCase;
  final WorkbenchSlotUseCase _workbenchSlotUseCase;

  WorkbenchBloc()
    : _craftUseCase = diContainer.get(),
      _workbenchSlotUseCase = diContainer.get(),
      super(const WorkbenchState()) {
    on<WorkbenchStarted>((event, emit) => emit(const WorkbenchState()));
    on<WorkbenchSlotTapped>(_onSlotTapped);
    on<WorkbenchCraftTapped>(_onCraftTapped);
  }

  void _onSlotTapped(
    WorkbenchSlotTapped event,
    Emitter<WorkbenchState> emit,
  ) => emit(
    state.copyWith(
      slots: _workbenchSlotUseCase(
        state.slots,
        event.index,
      ),
    ),
  );

  void _onCraftTapped(
    WorkbenchCraftTapped event,
    Emitter<WorkbenchState> emit,
  ) {
    if (_craftUseCase(state.slots)) {
      emit(state.copyWith(isDone: true));
    }
  }
}
