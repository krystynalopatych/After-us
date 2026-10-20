import 'package:data/day/repository/day_repository_impl.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts on the first day with no outcome',
    () {
      final repository = DayRepositoryImpl();

      expect(
        repository.day.number,
        1,
      );
      expect(
        repository.day.seconds,
        0,
      );
      expect(
        repository.outcome,
        isNull,
      );
    },
  );

  test(
    'emits the day and the outcome when they change',
    () async {
      final repository = DayRepositoryImpl();
      final days = <GameDay>[];
      final outcomes = <LevelOutcome?>[];
      final daySubscription = repository.dayStream.listen(days.add);
      final outcomeSubscription = repository.outcomeStream.listen(outcomes.add);
      addTearDown(daySubscription.cancel);
      addTearDown(outcomeSubscription.cancel);

      repository
        ..setDay(
          const GameDay(
            number: 2,
            seconds: 120,
          ),
        )
        ..setOutcome(.died);
      await pumpEventQueue();

      expect(
        repository.day.number,
        2,
      );
      expect(
        repository.day.seconds,
        120,
      );
      expect(
        repository.outcome,
        LevelOutcome.died,
      );
      expect(
        days.single.seconds,
        120,
      );
      expect(
        outcomes,
        [LevelOutcome.died],
      );
    },
  );

  test(
    'reset goes back to the first day and clears the outcome',
    () async {
      final repository = DayRepositoryImpl()
        ..setDay(
          const GameDay(
            number: 3,
            seconds: 500,
          ),
        )
        ..setOutcome(.noTimeLeft);
      final outcomes = <LevelOutcome?>[];
      final subscription = repository.outcomeStream.listen(outcomes.add);
      addTearDown(subscription.cancel);

      repository.reset();
      await pumpEventQueue();

      expect(
        repository.day.number,
        1,
      );
      expect(
        repository.day.seconds,
        0,
      );
      expect(
        repository.outcome,
        isNull,
      );
      expect(
        outcomes,
        [null],
      );
    },
  );
}
