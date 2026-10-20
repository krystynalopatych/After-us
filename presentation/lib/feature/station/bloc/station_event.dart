part of 'station_bloc.dart';

sealed class StationEvent extends Equatable {
  const StationEvent();

  @override
  List<Object?> get props => [];
}

final class StationStarted extends StationEvent {
  const StationStarted();
}
