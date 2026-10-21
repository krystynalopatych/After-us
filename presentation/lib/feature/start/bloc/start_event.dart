part of 'start_bloc.dart';

sealed class StartEvent extends Equatable {
  const StartEvent();

  @override
  List<Object?> get props => [];
}

final class StartStarted extends StartEvent {
  final bool isLevelSelection;

  const StartStarted({this.isLevelSelection = false});

  @override
  List<Object?> get props => [isLevelSelection];
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
