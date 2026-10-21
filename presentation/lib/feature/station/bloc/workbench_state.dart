part of 'workbench_bloc.dart';

final class WorkbenchState extends Equatable {
  static const emptySlots = <WorkbenchItem?>[null, null, null, null];

  final List<WorkbenchItem?> slots;
  final bool hasNewRecord;

  const WorkbenchState({
    this.slots = emptySlots,
    this.hasNewRecord = false,
  });

  WorkbenchState copyWith({
    List<WorkbenchItem?>? slots,
    bool? hasNewRecord,
  }) => WorkbenchState(
    slots: slots ?? this.slots,
    hasNewRecord: hasNewRecord ?? this.hasNewRecord,
  );

  @override
  List<Object?> get props => [slots, hasNewRecord];
}
