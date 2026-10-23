import 'package:data/dialogue/repository/dialogue_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'say sends every line to the listeners',
    () async {
      final repository = DialogueRepositoryImpl();
      final emitted = <String>[];
      final subscription = repository.lineStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository
        ..say('first')
        ..say('second');
      await pumpEventQueue();

      expect(
        emitted,
        ['first', 'second'],
      );
    },
  );
}
