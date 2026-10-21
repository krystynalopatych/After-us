import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/sun_spot/bloc/sun_spot_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'tapping the spot puts the selected bottle in the sun and follows its timer',
    () async {
      final bloc = SunSpotBloc()..add(const SunSpotStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();
      deps.inventory.add(.sodisStrainedWater);
      deps.selection.selectSlot(0);

      bloc.add(const SunSpotTapped());
      await pumpEventQueue();

      expect(
        bloc.state.bottle,
        const SunBottle(item: .sodisStrainedWater),
      );

      deps.sunSpot.tick();
      await pumpEventQueue();

      expect(
        bloc.state.bottle?.seconds,
        1,
      );
    },
  );
}
