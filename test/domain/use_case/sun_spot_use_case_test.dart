import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:domain/sun_spot/use_case/use_sun_spot_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late UseSunSpotUseCase useSunSpot;
  late List<FeedbackMessage> messages;

  setUp(() {
    deps = TestDependencies();
    useSunSpot = UseSunSpotUseCase(
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      selectionRepository: deps.selection,
      soundRepository: deps.sound,
      sunSpotRepository: deps.sunSpot,
    );
    messages = [];
    final subscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(subscription.cancel);
  });

  void warm() {
    for (var i = 0; i < SunBottle.readySeconds; i++) {
      deps.sunSpot.tick();
    }
  }

  test(
    'strained water in a SODIS bottle turns clean after five minutes',
    () async {
      deps.inventory.add(.sodisStrainedWater);
      deps.selection.selectSlot(0);

      expect(
        useSunSpot(),
        isTrue,
      );
      expect(
        deps.inventory.stacks,
        isEmpty,
      );
      expect(
        deps.sunSpot.bottle,
        const SunBottle(item: .sodisStrainedWater),
      );

      expect(
        useSunSpot(),
        isFalse,
      );
      warm();
      expect(
        deps.sunSpot.bottle?.isReady,
        isTrue,
      );

      expect(
        useSunSpot(),
        isTrue,
      );
      expect(
        deps.inventory.count(.sodisCleanWater),
        1,
      );
      expect(
        deps.sunSpot.bottle,
        isNull,
      );
      await pumpEventQueue();
      expect(
        messages.last.text,
        'The water in the bottle is clean',
      );
    },
  );

  test(
    'lake water stays dirty in the sun',
    () {
      deps.inventory.add(.sodisLakeWater);
      deps.selection.selectSlot(0);

      useSunSpot();
      warm();
      useSunSpot();

      expect(
        deps.inventory.count(.sodisLakeWater),
        1,
      );
    },
  );

  test(
    'clean water and other items are refused',
    () async {
      deps.inventory
        ..add(.sodisFilteredWater)
        ..add(.bottleStrainedWater);

      deps.selection.selectSlot(0);
      expect(
        useSunSpot(),
        isFalse,
      );
      deps.selection.selectSlot(1);
      expect(
        useSunSpot(),
        isFalse,
      );
      await pumpEventQueue();

      expect(
        messages.map((message) => message.text),
        ['This water is already ok', 'Only a SODIS bottle with water can go in the sun'],
      );
      expect(
        deps.sunSpot.bottle,
        isNull,
      );
    },
  );

  test(
    'only one bottle fits in the sun',
    () {
      deps.inventory
        ..add(.sodisStrainedWater)
        ..add(.sodisLakeWater);
      deps.selection.selectSlot(0);
      useSunSpot();

      deps.selection.selectSlot(0);
      expect(
        useSunSpot(),
        isFalse,
      );
      expect(
        deps.inventory.count(.sodisLakeWater),
        1,
      );
    },
  );
}
