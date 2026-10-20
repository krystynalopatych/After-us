part of 'station_build_bloc.dart';

sealed class StationBuildEvent extends Equatable {
  const StationBuildEvent();

  @override
  List<Object?> get props => [];
}

final class StationBuildStarted extends StationBuildEvent {
  const StationBuildStarted();
}

final class StationBuildTapped extends StationBuildEvent {
  final Station station;

  const StationBuildTapped(this.station);

  @override
  List<Object?> get props => [station];
}
