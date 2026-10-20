part of 'day_bloc.dart';

final class DayState extends Equatable {
  final GameDay day;
  final int levelDays;

  const DayState({
    required this.day,
    this.levelDays = 1,
  });

  DayState copyWith({
    GameDay? day,
    int? levelDays,
  }) => DayState(
    day: day ?? this.day,
    levelDays: levelDays ?? this.levelDays,
  );

  @override
  List<Object?> get props => [day, levelDays];
}
