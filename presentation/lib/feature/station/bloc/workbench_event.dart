part of 'workbench_bloc.dart';

sealed class WorkbenchEvent extends Equatable {
  const WorkbenchEvent();

  @override
  List<Object?> get props => [];
}

final class WorkbenchStarted extends WorkbenchEvent {
  const WorkbenchStarted();
}

final class WorkbenchSlotTapped extends WorkbenchEvent {
  final int index;

  const WorkbenchSlotTapped(this.index);

  @override
  List<Object?> get props => [index];
}

final class WorkbenchCraftTapped extends WorkbenchEvent {
  const WorkbenchCraftTapped();
}
