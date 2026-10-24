part of 'dialogue_bloc.dart';

sealed class DialogueEvent extends Equatable {
  const DialogueEvent();

  @override
  List<Object?> get props => [];
}

final class DialogueStarted extends DialogueEvent {
  const DialogueStarted();
}

final class DialogueLineTyped extends DialogueEvent {
  const DialogueLineTyped();
}

final class DialogueExpired extends DialogueEvent {
  const DialogueExpired();
}

final class DialogueWoke extends DialogueEvent {
  const DialogueWoke();
}
