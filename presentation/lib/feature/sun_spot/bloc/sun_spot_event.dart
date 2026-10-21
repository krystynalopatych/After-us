part of 'sun_spot_bloc.dart';

sealed class SunSpotEvent extends Equatable {
  const SunSpotEvent();

  @override
  List<Object?> get props => [];
}

final class SunSpotStarted extends SunSpotEvent {
  const SunSpotStarted();
}

final class SunSpotTapped extends SunSpotEvent {
  const SunSpotTapped();
}
