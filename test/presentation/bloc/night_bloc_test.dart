import 'package:domain/day/model/game_day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/night/bloc/night_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'follows the night and its progress',
    () async {
      final bloc = NightBloc()..add(const NightStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state.isNight,
        isFalse,
      );

      deps.day.setDay(
        const GameDay(
          number: 2,
          seconds: 0,
          nightSeconds: 4,
        ),
      );
      await pumpEventQueue();

      expect(
        bloc.state.isNight,
        isTrue,
      );
      expect(
        bloc.state.progress,
        closeTo(0.6, 0.001),
      );
    },
  );
}
