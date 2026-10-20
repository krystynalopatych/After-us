import 'package:domain/feedback/model/feedback_message.dart';

abstract interface class FeedbackRepository {
  Stream<FeedbackMessage> get messageStream;

  void show(FeedbackMessage message);
}
