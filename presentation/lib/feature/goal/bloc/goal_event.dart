part of 'goal_bloc.dart';

sealed class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object?> get props => [];
}

final class GoalStarted extends GoalEvent {
  const GoalStarted();
}
