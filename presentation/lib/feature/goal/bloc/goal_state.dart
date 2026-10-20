part of 'goal_bloc.dart';

final class GoalState extends Equatable {
  final Set<Construction> built;

  const GoalState({required this.built});

  GoalState copyWith({Set<Construction>? built}) => GoalState(built: built ?? this.built);

  @override
  List<Object?> get props => [built];
}
