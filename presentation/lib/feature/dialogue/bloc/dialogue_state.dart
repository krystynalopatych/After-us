part of 'dialogue_bloc.dart';

final class DialogueState extends Equatable {
  final String? line;
  final List<String> queue;

  const DialogueState({
    this.line,
    this.queue = const [],
  });

  DialogueState copyWith({
    String? Function()? line,
    List<String>? queue,
  }) => DialogueState(
    line: line != null ? line() : this.line,
    queue: queue ?? this.queue,
  );

  @override
  List<Object?> get props => [
    line,
    queue,
  ];
}
