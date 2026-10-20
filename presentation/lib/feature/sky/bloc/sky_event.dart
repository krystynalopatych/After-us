part of 'sky_bloc.dart';

sealed class SkyEvent extends Equatable {
  const SkyEvent();

  @override
  List<Object?> get props => [];
}

final class SkyStarted extends SkyEvent {
  const SkyStarted();
}
