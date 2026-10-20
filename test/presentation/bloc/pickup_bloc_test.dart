import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/pickup/bloc/pickup_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late PickupBloc bloc;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    deps.pickup.startLevel(.level1);
    bloc = PickupBloc()..add(const PickupStarted());
    await pumpEventQueue();
  });

  tearDown(() => bloc.close());

  Pickup firstOf(PickupKind kind) => bloc.state.pickups.firstWhere((pickup) => pickup.kind == kind);

  Future<void> send(PickupEvent event) async {
    bloc.add(event);
    await pumpEventQueue();
  }

  Future<void> moveTo(GameLocation location) async {
    deps.location.setLocation(location);
    await pumpEventQueue();
  }

  test(
    'shows only the pickups of the current location',
    () async {
      expect(
        bloc.state.pickups,
        isNotEmpty,
      );
      expect(
        bloc.state.pickups.every((pickup) => pickup.location == GameLocation.house),
        isTrue,
      );

      await moveTo(.lake);

      expect(
        bloc.state.pickups.every((pickup) => pickup.location == GameLocation.lake),
        isTrue,
      );
      expect(
        bloc.state.pickups.any((pickup) => pickup.kind == PickupKind.sand),
        isTrue,
      );
    },
  );

  test(
    'tapping a pickup opens the choice without collecting it',
    () async {
      final plastic = firstOf(.plastic);
      await send(PickupTapped(plastic));

      expect(
        bloc.state.found,
        same(plastic),
      );
      expect(
        bloc.state.step,
        PickupStep.choice,
      );
      expect(
        deps.material.stocks,
        isEmpty,
      );
      expect(
        bloc.state.pickups,
        contains(plastic),
      );
    },
  );

  test(
    'keeping a material adds it to the counter and removes it',
    () async {
      final plastic = firstOf(.plastic);
      await send(PickupTapped(plastic));
      await send(const PickupKeepTapped());

      expect(
        bloc.state.found,
        isNull,
      );
      expect(
        deps.material.stocks.single.material,
        GameMaterial.plastic,
      );
      expect(
        bloc.state.pickups,
        isNot(contains(plastic)),
      );
    },
  );

  test(
    'keeping food puts it into the inventory and removes it',
    () async {
      final bush = firstOf(.berryBush);
      await send(PickupTapped(bush));
      await send(const PickupKeepTapped());

      expect(
        deps.inventory.stacks.single.item,
        InventoryItem.berries,
      );
      expect(
        bloc.state.pickups,
        isNot(contains(bush)),
      );
      expect(
        deps.material.stocks,
        isEmpty,
      );
    },
  );

  test(
    'keeping food with a full inventory shows the message and leaves the pickup',
    () async {
      for (var i = 0; i < 60; i++) {
        deps.inventory.add(.algae);
      }
      final bush = firstOf(.berryBush);
      await send(PickupTapped(bush));
      await send(const PickupKeepTapped());

      expect(
        bloc.state.step,
        PickupStep.inventoryFull,
      );
      expect(
        bloc.state.found,
        same(bush),
      );
      expect(
        bloc.state.pickups,
        contains(bush),
      );

      await send(const PickupDismissed());

      expect(
        bloc.state.found,
        isNull,
      );
      expect(
        bloc.state.pickups,
        contains(bush),
      );
    },
  );

  test(
    'throw away asks where to throw it',
    () async {
      await send(PickupTapped(firstOf(.plastic)));
      await send(const PickupThrowTapped());

      expect(
        bloc.state.step,
        PickupStep.throwTarget,
      );
    },
  );

  test(
    'a material thrown into the lake pollutes the water',
    () async {
      final plastic = firstOf(.plastic);
      await send(PickupTapped(plastic));
      await send(const PickupThrowTapped());
      await send(const PickupThrowTargetTapped(.lake));

      expect(
        deps.pollution.pollution.isWaterPolluted,
        isTrue,
      );
      expect(
        deps.pollution.pollution.isSoilPolluted,
        isFalse,
      );
      expect(
        deps.pollution.pollution.airPoints,
        0,
      );
      expect(
        bloc.state.found,
        isNull,
      );
      expect(
        bloc.state.pickups,
        isNot(contains(plastic)),
      );
      expect(
        deps.material.stocks,
        isEmpty,
      );
    },
  );

  test(
    'a material thrown in the forest pollutes the soil',
    () async {
      await send(PickupTapped(firstOf(.plastic)));
      await send(const PickupThrowTapped());
      await send(const PickupThrowTargetTapped(.forest));

      expect(
        deps.pollution.pollution.isSoilPolluted,
        isTrue,
      );
      expect(
        deps.pollution.pollution.isWaterPolluted,
        isFalse,
      );
    },
  );

  test(
    'a material thrown at the dump adds its air points',
    () async {
      await send(PickupTapped(firstOf(.plastic)));
      await send(const PickupThrowTapped());
      await send(const PickupThrowTargetTapped(.dump));
      expect(
        deps.pollution.pollution.airPoints,
        3,
      );

      await moveTo(.dump);
      await send(PickupTapped(firstOf(.cloth)));
      await send(const PickupThrowTapped());
      await send(const PickupThrowTargetTapped(.dump));
      expect(
        deps.pollution.pollution.airPoints,
        5,
      );

      await send(PickupTapped(firstOf(.metal)));
      await send(const PickupThrowTapped());
      await send(const PickupThrowTargetTapped(.dump));
      expect(
        deps.pollution.pollution.airPoints,
        6,
      );
    },
  );

  test(
    'thrown food pollutes nothing',
    () async {
      for (final (place, target) in [
        (GameLocation.house, GameLocation.lake),
        (GameLocation.house, GameLocation.dump),
        (GameLocation.forest, GameLocation.forest),
      ]) {
        await moveTo(place);
        final bush = firstOf(.berryBush);
        await send(PickupTapped(bush));
        await send(const PickupThrowTapped());
        await send(PickupThrowTargetTapped(target));
        expect(
          bloc.state.pickups,
          isNot(contains(bush)),
        );
      }

      expect(
        deps.pollution.pollution.airPoints,
        0,
      );
      expect(
        deps.pollution.pollution.isWaterPolluted,
        isFalse,
      );
      expect(
        deps.pollution.pollution.isSoilPolluted,
        isFalse,
      );
      expect(
        deps.inventory.stacks,
        isEmpty,
      );
    },
  );

  test(
    'the open dialog survives a pickup list update',
    () async {
      final plastic = firstOf(.plastic);
      await send(PickupTapped(plastic));

      deps.pickup.collect(firstOf(.berryBush));
      await pumpEventQueue();

      expect(
        bloc.state.found,
        same(plastic),
      );
      expect(
        bloc.state.step,
        PickupStep.choice,
      );
    },
  );
}
