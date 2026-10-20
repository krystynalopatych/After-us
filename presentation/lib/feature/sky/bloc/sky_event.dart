part of 'sky_bloc.dart';

sealed class SkyEvent {
  const SkyEvent();
}

final class SkyStarted extends SkyEvent {
  const SkyStarted();
}
