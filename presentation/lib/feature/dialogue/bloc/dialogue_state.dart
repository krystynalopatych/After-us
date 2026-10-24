part of 'dialogue_bloc.dart';

final class DialogueState extends Equatable {
  final String? line;
  final List<String> queue;
  final bool isAwake;

  const DialogueState({
    this.line,
    this.queue = const [],
    this.isAwake = true,
  });

  DialogueState copyWith({
    String? Function()? line,
    List<String>? queue,
    bool? isAwake,
  }) => DialogueState(
    line: line != null ? line() : this.line,
    queue: queue ?? this.queue,
    isAwake: isAwake ?? this.isAwake,
  );

  @override
  List<Object?> get props => [
    line,
    queue,
    isAwake,
  ];
}
