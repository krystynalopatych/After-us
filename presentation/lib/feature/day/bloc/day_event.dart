part of 'day_bloc.dart';

sealed class DayEvent extends Equatable {
  const DayEvent();

  @override
  List<Object?> get props => [];
}

final class DayStarted extends DayEvent {
  final GameLevel level;

  const DayStarted(this.level);

  @override
  List<Object?> get props => [level];
}
