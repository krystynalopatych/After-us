part of 'compost_bloc.dart';

sealed class CompostEvent extends Equatable {
  const CompostEvent();

  @override
  List<Object?> get props => [];
}

final class CompostStarted extends CompostEvent {
  const CompostStarted();
}

final class CompostPitTapped extends CompostEvent {
  const CompostPitTapped();
}
