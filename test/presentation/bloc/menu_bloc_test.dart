import 'package:domain/day/model/game_day.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/menu/bloc/menu_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late MenuBloc bloc;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    bloc = MenuBloc()..add(const MenuStarted());
    await pumpEventQueue();
  });

  tearDown(() => bloc.close());

  test(
    'starts closed and not saved',
    () {
      expect(
        bloc.state.isOpen,
        isFalse,
      );
      expect(
        bloc.state.isSaved,
        isFalse,
      );
    },
  );

  test(
    'toggling opens and closes the panel, closing always closes it',
    () async {
      bloc.add(const MenuToggled());
      await pumpEventQueue();
      expect(
        bloc.state.isOpen,
        isTrue,
      );

      bloc.add(const MenuToggled());
      await pumpEventQueue();
      expect(
        bloc.state.isOpen,
        isFalse,
      );

      bloc
        ..add(const MenuToggled())
        ..add(const MenuClosed());
      await pumpEventQueue();
      expect(
        bloc.state.isOpen,
        isFalse,
      );
    },
  );

  test(
    'saving stores a full snapshot of the game and shows the check',
    () async {
      deps.location.setLocation(.forest);
      deps.day.setDay(
        const GameDay(
          number: 2,
          seconds: 50,
        ),
      );
      deps.player.setStats(
        const PlayerStats(
          health: 77,
          hunger: 44,
          thirst: 33,
        ),
      );
      deps.material.add(.wood);
      deps.inventory.add(.berries);
      deps.pickup.startLevel(.level1);
      deps.pollution.addAirPoints(2);

      bloc
        ..add(const MenuToggled())
        ..add(const MenuSaveTapped(.level1));
      await pumpEventQueue();

      final save = deps.save.saves.single;
      expect(
        save.level,
        GameLevel.level1,
      );
      expect(
        save.location,
        GameLocation.forest,
      );
      expect(
        save.day.number,
        2,
      );
      expect(
        save.day.seconds,
        50,
      );
      expect(
        save.stats.health,
        77,
      );
      expect(
        save.materials.single.material,
        GameMaterial.wood,
      );
      expect(
        save.inventory.single.item,
        InventoryItem.berries,
      );
      expect(
        save.pickups,
        hasLength(39),
      );
      expect(
        save.pollution.airPoints,
        2,
      );
      expect(
        bloc.state.isOpen,
        isTrue,
      );
      expect(
        bloc.state.isSaved,
        isTrue,
      );
    },
  );

  test(
    'the check goes away when the panel is toggled again',
    () async {
      bloc
        ..add(const MenuToggled())
        ..add(const MenuSaveTapped(.level1))
        ..add(const MenuToggled())
        ..add(const MenuToggled());
      await pumpEventQueue();

      expect(
        bloc.state.isOpen,
        isTrue,
      );
      expect(
        bloc.state.isSaved,
        isFalse,
      );
    },
  );

  test(
    'exiting the level stops the music',
    () async {
      deps.sound.loop(.backgroundMusic);

      bloc.add(const MenuExitTapped());
      await pumpEventQueue();

      expect(
        deps.sound.looping,
        isEmpty,
      );
    },
  );

  test(
    'starts with the sound on and the sound button mutes and unmutes it',
    () async {
      expect(
        bloc.state.isMuted,
        isFalse,
      );

      bloc.add(const MenuSoundTapped());
      await pumpEventQueue();
      expect(
        bloc.state.isMuted,
        isTrue,
      );
      expect(
        deps.sound.isMuted,
        isTrue,
      );

      bloc.add(const MenuSoundTapped());
      await pumpEventQueue();
      expect(
        bloc.state.isMuted,
        isFalse,
      );
      expect(
        deps.sound.isMuted,
        isFalse,
      );
    },
  );

  test(
    'the sound stays muted when the panel is toggled and in a new menu',
    () async {
      bloc
        ..add(const MenuToggled())
        ..add(const MenuSoundTapped());
      await pumpEventQueue();
      bloc
        ..add(const MenuToggled())
        ..add(const MenuClosed());
      await pumpEventQueue();
      expect(
        bloc.state.isMuted,
        isTrue,
      );

      final nextBloc = MenuBloc()..add(const MenuStarted());
      addTearDown(nextBloc.close);
      await pumpEventQueue();
      expect(
        nextBloc.state.isMuted,
        isTrue,
      );
    },
  );
}
