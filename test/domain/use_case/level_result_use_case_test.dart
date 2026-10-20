import 'package:data/construction/repository/construction_repository_impl.dart';
import 'package:data/day/repository/day_repository_impl.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/progress/model/level_result.dart';
import 'package:domain/progress/use_case/level_result_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ConstructionRepositoryImpl constructions;
  late DayRepositoryImpl day;
  late LevelResultUseCase levelResult;

  setUp(() {
    constructions = ConstructionRepositoryImpl();
    day = DayRepositoryImpl();
    levelResult = LevelResultUseCase(
      constructionRepository: constructions,
      dayRepository: day,
    );
  });

  test(
    'there is no result while the level is running',
    () {
      expect(
        levelResult.result(.level1),
        isNull,
      );
    },
  );

  test(
    'a loss lists the goals that were not built, in goal order',
    () {
      constructions.build(.compostPit);
      day.setOutcome(.noTimeLeft);

      expect(
        levelResult.result(.level1),
        const LevelResult(
          outcome: .noTimeLeft,
          missingGoals: [
            Construction.waterFilter,
            Construction.rocketStove,
          ],
        ),
      );
    },
  );

  test(
    'a win has no missing goals',
    () {
      constructions
        ..build(.waterFilter)
        ..build(.compostPit)
        ..build(.rocketStove);
      day.setOutcome(.won);

      expect(
        levelResult.result(.level1),
        const LevelResult(outcome: .won),
      );
    },
  );

  test(
    'the result stream follows the outcome',
    () async {
      final results = <LevelResult?>[];
      final subscription = levelResult.resultStream(.level1).listen(results.add);
      addTearDown(subscription.cancel);

      day.setOutcome(.died);
      await pumpEventQueue();
      day.reset();
      await pumpEventQueue();

      expect(
        results.first?.outcome,
        LevelOutcome.died,
      );
      expect(
        results.last,
        isNull,
      );
    },
  );
}
