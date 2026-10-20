import 'package:domain/day/model/game_day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/day/bloc/day_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late DayBloc bloc;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    bloc = DayBloc()..add(const DayStarted(.level1));
    await pumpEventQueue();
  });

  tearDown(() => bloc.close());

  Future<void> tick([int count = 1]) async {
    deps.ticker.tick(count);
    await pumpEventQueue();
  }

  test(
    'starts on the stored day with the level length',
    () {
      expect(
        bloc.state.day,
        const GameDay.first(),
      );
      expect(
        bloc.state.levelDays,
        3,
      );
    },
  );

  test(
    'every tick passes one second of the day',
    () async {
      await tick(5);

      expect(
        bloc.state.day.seconds,
        5,
      );
      expect(
        deps.day.day.seconds,
        5,
      );
      expect(
        deps.player.stats.thirst,
        lessThan(80),
      );
    },
  );

  test(
    'shows the next day when the day ends',
    () async {
      await tick(GameDay.secondsPerDay);

      expect(
        bloc.state.day,
        const GameDay(
          number: 2,
          seconds: 0,
        ),
      );
    },
  );

  test(
    'follows a day restored from a save',
    () async {
      deps.day.restore(
        const GameDay(
          number: 2,
          seconds: 200,
        ),
      );
      await pumpEventQueue();

      expect(
        bloc.state.day.number,
        2,
      );

      await tick();

      expect(
        deps.day.day.seconds,
        201,
      );
    },
  );
}
