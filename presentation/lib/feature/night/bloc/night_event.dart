part of 'night_bloc.dart';

sealed class NightEvent extends Equatable {
  const NightEvent();

  @override
  List<Object?> get props => [];
}

final class NightStarted extends NightEvent {
  const NightStarted();
}
