import 'package:domain/compost/model/compost_pit.dart';
import 'package:domain/compost/use_case/use_compost_pit_use_case.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late UseCompostPitUseCase useCompostPit;
  late List<FeedbackMessage> messages;

  setUp(() {
    deps = TestDependencies();
    useCompostPit = UseCompostPitUseCase(
      compostRepository: deps.compost,
      feedbackRepository: deps.feedback,
      materialRepository: deps.material,
      selectionRepository: deps.selection,
      soundRepository: deps.sound,
    );
    messages = [];
    final subscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(subscription.cancel);
  });

  void addOrganics(int count) {
    for (var i = 0; i < count; i++) {
      deps.material.add(.organics);
    }
  }

  test(
    'puts one organics pile at a time and starts composting at four',
    () async {
      addOrganics(5);
      deps.selection.selectMaterial(.organics);

      for (var i = 0; i < 4; i++) {
        expect(
          useCompostPit(),
          isTrue,
        );
      }

      expect(
        deps.compost.pit,
        const CompostPit(
          organics: 4,
          seconds: 0,
        ),
      );
      expect(
        deps.material.count(.organics),
        1,
      );
      await pumpEventQueue();
      expect(
        messages.first.text,
        'You put organics in the pit 1/4',
      );
      expect(
        messages.last.text,
        'The pit is full the compost will be ready in a day',
      );

      expect(
        useCompostPit(),
        isFalse,
      );
      expect(
        deps.material.count(.organics),
        1,
      );
    },
  );

  test(
    'ready compost goes to the counter and the pit is empty again',
    () {
      deps.compost.restore(
        const CompostPit(
          organics: 4,
          seconds: CompostPit.readySeconds,
        ),
      );

      expect(
        useCompostPit(),
        isTrue,
      );
      expect(
        deps.material.count(.compost),
        2,
      );
      expect(
        deps.compost.pit,
        const CompostPit.empty(),
      );
    },
  );

  test(
    'only organics go in the pit',
    () async {
      deps.material.add(.wood);
      deps.selection.selectMaterial(.wood);

      expect(
        useCompostPit(),
        isFalse,
      );
      await pumpEventQueue();
      expect(
        messages.single.text,
        'Only organics can go in the compost pit',
      );
    },
  );

  test(
    'a tap without a selection does nothing',
    () async {
      expect(
        useCompostPit(),
        isFalse,
      );
      await pumpEventQueue();
      expect(
        messages,
        isEmpty,
      );
    },
  );
}
