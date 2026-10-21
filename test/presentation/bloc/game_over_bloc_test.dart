import 'package:domain/construction/model/construction.dart';
import 'package:domain/progress/model/game_level.dart';
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
    'continue after a win unlocks the next level and finishes',
    () async {
      final bloc = GameOverBloc(level: .level1)..add(const GameOverStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();
      deps.day.setOutcome(.won);
      await pumpEventQueue();

      bloc.add(const GameOverContinueTapped());
      await pumpEventQueue();

      expect(
        bloc.state.isCompleted,
        isTrue,
      );
      expect(
        deps.progress.unlockedLevel,
        GameLevel.level2,
      );
    },
  );
}
