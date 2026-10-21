part of 'workbench_bloc.dart';

final class WorkbenchState extends Equatable {
  final List<WorkbenchItem?> slots;
  final bool isDone;

  const WorkbenchState({
    this.slots = const [null, null, null, null],
    this.isDone = false,
  });

  WorkbenchState copyWith({
    List<WorkbenchItem?>? slots,
    bool? isDone,
  }) => WorkbenchState(
    slots: slots ?? this.slots,
    isDone: isDone ?? this.isDone,
  );

  @override
  List<Object?> get props => [slots, isDone];
}
