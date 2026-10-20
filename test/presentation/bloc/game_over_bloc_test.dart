import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/progress/model/level_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/game_over/bloc/game_over_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'shows the level result and follows its changes',
    () async {
      final bloc = GameOverBloc(level: .level1)..add(const GameOverStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state.result,
        isNull,
      );

      deps.construction.build(.rocketStove);
      deps.day.setOutcome(.noTimeLeft);
      await pumpEventQueue();

      expect(
        bloc.state.result,
        const LevelResult(
          outcome: .noTimeLeft,
          missingGoals: [
            Construction.waterFilter,
            Construction.compostPit,
          ],
        ),
      );
    },
  );

  test(
    'retry restarts the level and hides the screen',
    () async {
      final bloc = GameOverBloc(level: .level1)..add(const GameOverStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      deps.construction.build(.rocketStove);
      deps.day
        ..setDay(
          const GameDay(
            number: 3,
            seconds: 599,
          ),
        )
        ..setOutcome(.died);
      await pumpEventQueue();

      expect(
        bloc.state.result?.outcome,
        LevelOutcome.died,
      );

      bloc.add(const GameOverRetryTapped());
      await pumpEventQueue();

      expect(
        bloc.state.result,
        isNull,
      );
      expect(
        deps.day.day,
        const GameDay.first(),
      );
      expect(
        deps.construction.built,
        isEmpty,
      );
    },
  );
}
