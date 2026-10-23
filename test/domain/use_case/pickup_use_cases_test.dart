import 'package:data/book/repository/book_repository_impl.dart';
import 'package:data/dialogue/repository/dialogue_repository_impl.dart';
import 'package:data/inventory/repository/inventory_repository_impl.dart';
import 'package:data/location/repository/location_repository_impl.dart';
import 'package:data/material/repository/material_repository_impl.dart';
import 'package:data/pickup/repository/pickup_hint_repository_impl.dart';
import 'package:data/pickup/repository/pickup_repository_impl.dart';
import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:domain/pickup/use_case/keep_pickup_use_case.dart';
import 'package:domain/pickup/use_case/location_pickups_use_case.dart';
import 'package:domain/pickup/use_case/throw_pickup_use_case.dart';
import 'package:domain/progress/use_case/new_game_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DialogueRepositoryImpl dialogue;
  late InventoryRepositoryImpl inventory;
  late LocationRepositoryImpl location;
  late MaterialRepositoryImpl material;
  late PickupRepositoryImpl pickup;
  late PickupHintRepositoryImpl pickupHint;
  late PollutionRepositoryImpl pollution;

  setUp(() {
    dialogue = DialogueRepositoryImpl();
    inventory = InventoryRepositoryImpl();
    location = LocationRepositoryImpl();
    material = MaterialRepositoryImpl();
    pickup = PickupRepositoryImpl()..startLevel(.level1);
    pickupHint = PickupHintRepositoryImpl();
    pollution = PollutionRepositoryImpl();
  });

  Pickup firstOf(PickupKind kind) => pickup.pickups.firstWhere((item) => item.kind == kind);

  group(
    'KeepPickupUseCase',
    () {
      late KeepPickupUseCase keep;

      setUp(
        () => keep = KeepPickupUseCase(
          dialogueRepository: dialogue,
          inventoryRepository: inventory,
          materialRepository: material,
          pickupHintRepository: pickupHint,
          pickupRepository: pickup,
        ),
      );

      test(
        'a material goes to the counter and leaves the location',
        () {
          final plastic = firstOf(.plastic);

          expect(
            keep(plastic),
            isTrue,
          );
          expect(
            material.count(.plastic),
            1,
          );
          expect(
            pickup.pickups,
            isNot(contains(plastic)),
          );
          expect(
            inventory.stacks,
            isEmpty,
          );
        },
      );

      test(
        'food goes to the inventory and leaves the location',
        () {
          final bush = firstOf(.berryBush);

          expect(
            keep(bush),
            isTrue,
          );
          expect(
            inventory.count(.berries),
            1,
          );
          expect(
            pickup.pickups,
            isNot(contains(bush)),
          );
          expect(
            material.stocks,
            isEmpty,
          );
        },
      );

      test(
        'food stays on the location when the inventory is full',
        () {
          for (var i = 0; i < 60; i++) {
            inventory.add(.algae);
          }
          final bush = firstOf(.berryBush);

          expect(
            keep(bush),
            isFalse,
          );
          expect(
            pickup.pickups,
            contains(bush),
          );
          expect(
            inventory.count(.berries),
            0,
          );
        },
      );
      test(
        'the hero says the hint only the first time a kind is kept',
        () async {
          final lines = <String>[];
          final subscription = dialogue.lineStream.listen(lines.add);
          addTearDown(subscription.cancel);

          final plastics = pickup.pickups.where((item) => item.kind == .plastic).toList();
          keep(plastics[0]);
          keep(plastics[1]);
          keep(firstOf(.sand));
          await pumpEventQueue();

          expect(
            lines,
            [
              PickupKind.plastic.hint,
              PickupKind.sand.hint,
            ],
          );
          expect(
            pickupHint.heard,
            {
              PickupKind.plastic,
              PickupKind.sand,
            },
          );
        },
      );

      test(
        'no hint when the food does not fit into the inventory',
        () {
          for (var i = 0; i < 60; i++) {
            inventory.add(.algae);
          }
          keep(firstOf(.berryBush));

          expect(
            pickupHint.heard,
            isEmpty,
          );
        },
      );

      test(
        'a new game lets the hints play again',
        () {
          keep(firstOf(.wood));
          NewGameUseCase(
            bookRepository: BookRepositoryImpl(),
            pickupHintRepository: pickupHint,
            progressRepository: ProgressRepositoryImpl(),
          )();

          expect(
            pickupHint.heard,
            isEmpty,
          );
        },
      );
    },
  );

  group(
    'ThrowPickupUseCase',
    () {
      late ThrowPickupUseCase throwAway;

      setUp(
        () => throwAway = ThrowPickupUseCase(
          pickupRepository: pickup,
          pollutionRepository: pollution,
        ),
      );

      test(
        'a material thrown into the lake pollutes the water',
        () {
          final plastic = firstOf(.plastic);
          throwAway(
            plastic,
            .lake,
          );

          expect(
            pollution.pollution.isWaterPolluted,
            isTrue,
          );
          expect(
            pollution.pollution.isSoilPolluted,
            isFalse,
          );
          expect(
            pollution.pollution.airPoints,
            0,
          );
          expect(
            pickup.pickups,
            isNot(contains(plastic)),
          );
        },
      );

      test(
        'sand, wood, cloth and organics do not pollute the lake and plastic does not pollute the soil',
        () {
          for (final kind in [PickupKind.sand, PickupKind.wood, PickupKind.cloth, PickupKind.organics]) {
            throwAway(
              firstOf(kind),
              .lake,
            );
          }
          throwAway(
            firstOf(.plastic),
            .forest,
          );

          expect(
            pollution.pollution.isSoilPolluted,
            isFalse,
          );
          expect(
            pollution.pollution.isWaterPolluted,
            isFalse,
          );
        },
      );

      test(
        'a material thrown at the dump adds its air points',
        () {
          throwAway(
            firstOf(.plastic),
            .dump,
          );
          expect(
            pollution.pollution.airPoints,
            GameMaterial.plastic.airPoints,
          );

          throwAway(
            firstOf(.metal),
            .dump,
          );
          expect(
            pollution.pollution.airPoints,
            GameMaterial.plastic.airPoints + GameMaterial.metal.airPoints,
          );
        },
      );

      test(
        'thrown food pollutes nothing but still leaves the location',
        () {
          for (final target in [GameLocation.lake, GameLocation.forest, GameLocation.dump]) {
            final bush = firstOf(.berryBush);
            throwAway(
              bush,
              target,
            );
            expect(
              pickup.pickups,
              isNot(contains(bush)),
            );
          }

          expect(
            pollution.pollution.airPoints,
            0,
          );
          expect(
            pollution.pollution.isWaterPolluted,
            isFalse,
          );
          expect(
            pollution.pollution.isSoilPolluted,
            isFalse,
          );
          expect(
            inventory.count(InventoryItem.berries),
            0,
          );
        },
      );
    },
  );

  group(
    'LocationPickupsUseCase',
    () {
      late LocationPickupsUseCase locationPickups;

      setUp(
        () => locationPickups = LocationPickupsUseCase(
          locationRepository: location,
          pickupRepository: pickup,
        ),
      );

      test(
        'gives only the pickups of the current location',
        () {
          expect(
            locationPickups.pickups,
            isNotEmpty,
          );
          expect(
            locationPickups.pickups.every((item) => item.location == GameLocation.house),
            isTrue,
          );
        },
      );

      test(
        'updates when the player moves or a pickup is collected',
        () async {
          final emitted = <List<Pickup>>[];
          final subscription = locationPickups.pickupsStream.listen(emitted.add);
          addTearDown(subscription.cancel);

          location.setLocation(.lake);
          await pumpEventQueue();
          expect(
            emitted.last.every((item) => item.location == GameLocation.lake),
            isTrue,
          );

          final sand = emitted.last.firstWhere((item) => item.kind == PickupKind.sand);
          pickup.collect(sand);
          await pumpEventQueue();
          expect(
            emitted.last,
            isNot(contains(sand)),
          );
          expect(
            emitted,
            hasLength(2),
          );
        },
      );
    },
  );
}
