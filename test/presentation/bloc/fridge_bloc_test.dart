import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/fridge/bloc/fridge_bloc.dart';
import 'package:presentation/feature/game/bloc/game_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'shows the fridge slots and whether it was watered today',
    () async {
      final bloc = FridgeBloc()..add(const FridgeStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state,
        const FridgeState(),
      );

      deps.inventory.add(.berries);
      deps.selection.selectSlot(0);
      bloc.add(const FridgeSlotTapped(1));
      deps.fridge.water(1);
      await pumpEventQueue();

      expect(
        bloc.state,
        const FridgeState(
          slots: [
            null,
            InventoryStack(
              item: .berries,
              count: 1,
            ),
            null,
            null,
          ],
          isCooling: true,
        ),
      );
    },
  );

  test(
    'tapping the fridge with lake water waters it, otherwise opens it',
    () async {
      final bloc = GameBloc()..add(const GameStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();
      deps.inventory.add(.bottleLakeWater);
      deps.selection.selectSlot(0);

      bloc.add(const GameStationTapped(.clayFridge));
      await pumpEventQueue();

      expect(
        bloc.state.isFridgeOpen,
        isFalse,
      );
      expect(
        deps.fridge.fridge.wateredDay,
        1,
      );

      bloc.add(const GameStationTapped(.clayFridge));
      await pumpEventQueue();
      expect(
        bloc.state.isFridgeOpen,
        isTrue,
      );

      bloc.add(const GameFridgeClosed());
      await pumpEventQueue();
      expect(
        bloc.state.isFridgeOpen,
        isFalse,
      );
    },
  );
}
