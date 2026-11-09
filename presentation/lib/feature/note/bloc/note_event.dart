part of 'note_bloc.dart';

sealed class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

final class NoteStarted extends NoteEvent {
  const NoteStarted();
}

final class NoteTapped extends NoteEvent {
  const NoteTapped();
}

final class NoteClosed extends NoteEvent {
  const NoteClosed();
}
