import 'package:data/feedback/repository/feedback_repository_impl.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'show sends every message to the listeners',
    () async {
      final repository = FeedbackRepositoryImpl();
      final emitted = <FeedbackMessage>[];
      final subscription = repository.messageStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository
        ..show(const FeedbackMessage(text: 'first'))
        ..show(
          const FeedbackMessage(
            text: 'second',
            heroLine: 'line',
            mood: .sad,
          ),
        );
      await pumpEventQueue();

      expect(
        emitted.map((message) => message.text),
        ['first', 'second'],
      );
      expect(
        emitted.last.heroLine,
        'line',
      );
    },
  );
}
