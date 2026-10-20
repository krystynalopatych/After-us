import 'dart:async';

import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';

final class FeedbackRepositoryImpl implements FeedbackRepository {
  final _messageController = StreamController<FeedbackMessage>.broadcast();

  @override
  Stream<FeedbackMessage> get messageStream => _messageController.stream;

  @override
  void show(FeedbackMessage message) => _messageController.add(message);
}
