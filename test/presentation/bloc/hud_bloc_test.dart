import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/hud/bloc/hud_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late HudBloc bloc;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    bloc = HudBloc()..add(const HudStarted());
    await pumpEventQueue();
  });

  tearDown(() => bloc.close());

  test(
    'starts with the stored stats, materials and inventory',
    () {
      expect(
        bloc.state.stats.thirst,
        80,
      );
      expect(
        bloc.state.stocks,
        isEmpty,
      );
      expect(
        bloc.state.inventory,
        isEmpty,
      );
      expect(
        bloc.state.selectedMaterial,
        isNull,
      );
      expect(
        bloc.state.selectedSlot,
        isNull,
      );
    },
  );

  test(
    'follows stats, materials and inventory changes',
    () async {
      deps.player.setStats(
        const .new(
          health: 70,
          hunger: 60,
          thirst: 50,
        ),
      );
      deps.material.add(.wood);
      deps.inventory.add(.berries);
      await pumpEventQueue();

      expect(
        bloc.state.stats.health,
        70,
      );
      expect(
        bloc.state.stocks.single.material,
        GameMaterial.wood,
      );
      expect(
        bloc.state.inventory.single.item,
        InventoryItem.berries,
      );
    },
  );

  test(
    'tapping a material selects it and tapping again clears it',
    () async {
      bloc.add(const HudMaterialTapped(.wood));
      await pumpEventQueue();
      expect(
        bloc.state.selectedMaterial,
        GameMaterial.wood,
      );

      bloc.add(const HudMaterialTapped(.wood));
      await pumpEventQueue();
      expect(
        bloc.state.selectedMaterial,
        isNull,
      );
    },
  );

  test(
    'tapping a slot selects it and tapping again clears it',
    () async {
      bloc.add(const HudSlotTapped(2));
      await pumpEventQueue();
      expect(
        bloc.state.selectedSlot,
        2,
      );

      bloc.add(const HudSlotTapped(2));
      await pumpEventQueue();
      expect(
        bloc.state.selectedSlot,
        isNull,
      );
    },
  );

  test(
    'only one item can be selected at a time',
    () async {
      bloc.add(const HudMaterialTapped(.plastic));
      await pumpEventQueue();
      bloc.add(const HudSlotTapped(0));
      await pumpEventQueue();

      expect(
        bloc.state.selectedSlot,
        0,
      );
      expect(
        bloc.state.selectedMaterial,
        isNull,
      );

      bloc.add(const HudMaterialTapped(.metal));
      await pumpEventQueue();

      expect(
        bloc.state.selectedMaterial,
        GameMaterial.metal,
      );
      expect(
        bloc.state.selectedSlot,
        isNull,
      );
    },
  );

  test(
    'the selection stays when stats or items change',
    () async {
      bloc.add(const HudSlotTapped(1));
      await pumpEventQueue();

      deps.player.setStats(
        const .new(
          health: 90,
          hunger: 70,
          thirst: 60,
        ),
      );
      deps.inventory.add(.algae);
      await pumpEventQueue();

      expect(
        bloc.state.selectedSlot,
        1,
      );
    },
  );
}
