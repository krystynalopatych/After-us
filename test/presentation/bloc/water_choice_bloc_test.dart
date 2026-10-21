import 'package:domain/inventory/model/water_bottle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/water/bloc/water_choice_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'offers the bottles the player has and fills the chosen one',
    () async {
      deps.material.add(.plastic);
      final bloc = WaterChoiceBloc()..add(const WaterChoiceStarted(.strained));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state.bottles,
        {WaterBottle.plastic},
      );

      bloc.add(const WaterChoiceBottleTapped(.plastic));
      await pumpEventQueue();

      expect(
        bloc.state.isDone,
        isTrue,
      );
      expect(
        deps.inventory.count(.bottleStrainedWater),
        1,
      );
      expect(
        deps.material.count(.plastic),
        0,
      );
    },
  );
}
