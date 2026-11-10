part of 'time_speed_bloc.dart';

final class TimeSpeedState extends Equatable {
  final bool isFast;
  final bool isNight;

  const TimeSpeedState({
    this.isFast = false,
    this.isNight = false,
  });

  TimeSpeedState copyWith({
    bool? isFast,
    bool? isNight,
  }) => TimeSpeedState(
    isFast: isFast ?? this.isFast,
    isNight: isNight ?? this.isNight,
  );

  @override
  List<Object?> get props => [isFast, isNight];
}
