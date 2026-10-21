import 'package:domain/material/model/game_material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/station/bloc/workbench_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late WorkbenchBloc bloc;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    bloc = WorkbenchBloc()..add(const WorkbenchStarted());
    await pumpEventQueue();
  });

  tearDown(() => bloc.close());

  test(
    'places materials into slots and crafts them',
    () async {
      deps.material
        ..add(.metal)
        ..add(.metal)
        ..add(.metal);
      deps.selection.selectMaterial(.metal);

      for (final index in [0, 1, 3]) {
        bloc.add(WorkbenchSlotTapped(index));
      }
      await pumpEventQueue();

      expect(
        bloc.state,
        const WorkbenchState(slots: [GameMaterial.metal, GameMaterial.metal, null, GameMaterial.metal]),
      );

      bloc.add(const WorkbenchCraftTapped());
      await pumpEventQueue();

      expect(
        bloc.state.isDone,
        isTrue,
      );
      expect(
        deps.inventory.count(.rocketStove),
        1,
      );
    },
  );

  test(
    'stays open with the slots when nothing can be crafted',
    () async {
      deps.material
        ..add(.metal)
        ..add(.metal);
      deps.selection.selectMaterial(.metal);
      bloc
        ..add(const WorkbenchSlotTapped(0))
        ..add(const WorkbenchSlotTapped(1))
        ..add(const WorkbenchCraftTapped());
      await pumpEventQueue();

      expect(
        bloc.state,
        const WorkbenchState(slots: [GameMaterial.metal, GameMaterial.metal, null, null]),
      );
    },
  );
}
