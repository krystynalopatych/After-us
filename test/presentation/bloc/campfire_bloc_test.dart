import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/station/bloc/campfire_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late CampfireBloc bloc;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    bloc = CampfireBloc()..add(const CampfireStarted());
    await pumpEventQueue();
  });

  tearDown(() => bloc.close());

  test(
    'puts the item into the slot, waits for fuel, then cooks and finishes',
    () async {
      deps.inventory
        ..add(.cookingPot)
        ..add(.lakeWater);
      deps.material.add(.wood);
      deps.selection.selectSlot(1);

      bloc.add(const CampfireSlotTapped());
      await pumpEventQueue();

      expect(
        bloc.state,
        const CampfireState(
          step: .fuel,
          recipe: .boilWater,
        ),
      );

      deps.selection.selectMaterial(.wood);
      await pumpEventQueue();

      expect(
        bloc.state,
        const CampfireState(
          step: .cooking,
          recipe: .boilWater,
          fuel: .wood,
        ),
      );
      expect(
        deps.inventory.count(.cleanWater),
        0,
      );

      await Future<void>.delayed(const Duration(milliseconds: 1100));

      expect(
        bloc.state.step,
        CampfireStep.done,
      );
      expect(
        deps.inventory.count(.cleanWater),
        2,
      );
      expect(
        deps.material.count(.wood),
        0,
      );
    },
  );

  test(
    'keeps waiting for fuel when the material does not burn',
    () async {
      deps.inventory
        ..add(.cookingPot)
        ..add(.lakeWater);
      deps.material.add(.sand);
      deps.selection.selectSlot(1);
      bloc.add(const CampfireSlotTapped());
      await pumpEventQueue();

      deps.selection.selectMaterial(.sand);
      await pumpEventQueue();

      expect(
        bloc.state,
        const CampfireState(
          step: .fuel,
          recipe: .boilWater,
        ),
      );
    },
  );

  test(
    'ignores materials picked before an item is in the slot',
    () async {
      deps.material.add(.wood);
      deps.selection.selectMaterial(.wood);
      await pumpEventQueue();

      expect(
        bloc.state,
        const CampfireState(),
      );
    },
  );

  test(
    'stays empty when the selection cannot be used',
    () async {
      deps.material.add(.sand);
      deps.selection.selectMaterial(.sand);

      bloc.add(const CampfireSlotTapped());
      await pumpEventQueue();

      expect(
        bloc.state,
        const CampfireState(),
      );
    },
  );
}
