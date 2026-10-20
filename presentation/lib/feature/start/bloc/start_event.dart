part of 'start_bloc.dart';

sealed class StartEvent extends Equatable {
  const StartEvent();

  @override
  List<Object?> get props => [];
}

final class StartStarted extends StartEvent {
  const StartStarted();
}

final class StartNewGameTapped extends StartEvent {
  const StartNewGameTapped();
}

final class StartExitTapped extends StartEvent {
  const StartExitTapped();
}

final class StartBackTapped extends StartEvent {
  const StartBackTapped();
}
