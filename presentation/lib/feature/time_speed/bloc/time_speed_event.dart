part of 'time_speed_bloc.dart';

sealed class TimeSpeedEvent extends Equatable {
  const TimeSpeedEvent();

  @override
  List<Object?> get props => [];
}

final class TimeSpeedStarted extends TimeSpeedEvent {
  const TimeSpeedStarted();
}

final class TimeSpeedToggled extends TimeSpeedEvent {
  const TimeSpeedToggled();
}
