import 'package:domain/day/model/game_day.dart';
import 'package:domain/time_speed/use_case/set_time_speed_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'speeds time up and slows it back down during the day',
    () {
      final setTimeSpeed = diContainer.get<SetTimeSpeedUseCase>();

      setTimeSpeed(true);
      expect(
        deps.timeSpeed.isFast,
        isTrue,
      );
      setTimeSpeed(false);
      expect(
        deps.timeSpeed.isFast,
        isFalse,
      );
    },
  );

  test(
    'keeps normal speed at night',
    () {
      final setTimeSpeed = diContainer.get<SetTimeSpeedUseCase>();

      setTimeSpeed(true);
      deps.day.setDay(
        const GameDay(
          number: 2,
          seconds: 0,
          nightSeconds: GameDay.nightLength,
        ),
      );
      setTimeSpeed(true);

      expect(
        deps.timeSpeed.isFast,
        isFalse,
      );
    },
  );
}
