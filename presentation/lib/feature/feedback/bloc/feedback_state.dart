part of 'feedback_bloc.dart';

final class FeedbackState extends Equatable {
  final FeedbackMessage? message;
  final List<FeedbackMessage> queue;

  const FeedbackState({
    this.message,
    this.queue = const [],
  });

  FeedbackState copyWith({
    FeedbackMessage? Function()? message,
    List<FeedbackMessage>? queue,
  }) => FeedbackState(
    message: message != null ? message() : this.message,
    queue: queue ?? this.queue,
  );

  @override
  List<Object?> get props => [
    message,
    queue,
  ];
}
