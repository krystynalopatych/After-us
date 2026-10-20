part of 'feedback_bloc.dart';

sealed class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

final class FeedbackStarted extends FeedbackEvent {
  const FeedbackStarted();
}

final class FeedbackExpired extends FeedbackEvent {
  const FeedbackExpired();
}
