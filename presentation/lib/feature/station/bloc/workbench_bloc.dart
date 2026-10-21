import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/workbench_slot_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/di/di_container.dart';

part 'workbench_event.dart';
part 'workbench_state.dart';

class WorkbenchBloc extends Bloc<WorkbenchEvent, WorkbenchState> {
  final BookRepository _bookRepository;
  final CraftUseCase _craftUseCase;
  final WorkbenchSlotUseCase _workbenchSlotUseCase;

  WorkbenchBloc()
    : _bookRepository = diContainer.get(),
      _craftUseCase = diContainer.get(),
      _workbenchSlotUseCase = diContainer.get(),
      super(const WorkbenchState()) {
    on<WorkbenchStarted>(_onStarted);
    on<WorkbenchSlotTapped>(_onSlotTapped);
    on<WorkbenchCraftTapped>(_onCraftTapped);
  }

  Future<void> _onStarted(
    WorkbenchStarted event,
    Emitter<WorkbenchState> emit,
  ) {
    emit(WorkbenchState(hasNewRecord: _bookRepository.book.hasNewRecord));
    return emit.forEach(
      _bookRepository.bookStream,
      onData: (book) => state.copyWith(hasNewRecord: book.hasNewRecord),
    );
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
      emit(state.copyWith(slots: WorkbenchState.emptySlots));
    }
  }
}
