part of 'start_bloc.dart';

sealed class StartEvent {
  const StartEvent();
}

final class StartStarted extends StartEvent {
  const StartStarted();
}
