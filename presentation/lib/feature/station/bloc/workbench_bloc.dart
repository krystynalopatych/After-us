import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/repository/workbench_repository.dart';
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
  final WorkbenchRepository _workbenchRepository;
  final WorkbenchSlotUseCase _workbenchSlotUseCase;

  WorkbenchBloc()
    : _bookRepository = diContainer.get(),
      _craftUseCase = diContainer.get(),
      _workbenchRepository = diContainer.get(),
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
    emit(
      WorkbenchState(
        slots: _workbenchRepository.slots,
        hasNewRecord: _bookRepository.book.hasNewRecord,
      ),
    );
    return Future.wait([
      emit.forEach(
        _bookRepository.bookStream,
        onData: (book) => state.copyWith(hasNewRecord: book.hasNewRecord),
      ),
      emit.forEach(
        _workbenchRepository.slotsStream,
        onData: (slots) => state.copyWith(slots: slots),
      ),
    ]);
  }

  void _onSlotTapped(
    WorkbenchSlotTapped event,
    Emitter<WorkbenchState> emit,
  ) => _workbenchSlotUseCase(event.index);

  void _onCraftTapped(
    WorkbenchCraftTapped event,
    Emitter<WorkbenchState> emit,
  ) => _craftUseCase();
}
