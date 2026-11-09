part of 'note_bloc.dart';

final class NoteState extends Equatable {
  final GameLocation location;
  final bool isOpen;

  const NoteState({
    required this.location,
    this.isOpen = false,
  });

  NoteState copyWith({
    GameLocation? location,
    bool? isOpen,
  }) => NoteState(
    location: location ?? this.location,
    isOpen: isOpen ?? this.isOpen,
  );

  @override
  List<Object?> get props => [location, isOpen];
}
