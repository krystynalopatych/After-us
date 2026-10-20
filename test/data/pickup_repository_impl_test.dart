import 'package:data/pickup/repository/pickup_repository_impl.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int count(
    List<Pickup> pickups,
    GameLocation location,
    PickupKind kind,
  ) => pickups.where((pickup) => pickup.location == location && pickup.kind == kind).length;

  test(
    'starts empty',
    () {
      expect(
        PickupRepositoryImpl().pickups,
        isEmpty,
      );
    },
  );

  test(
    'lays out level 1 resources where the user placed them',
    () {
      final pickups = (PickupRepositoryImpl()..startLevel(.level1)).pickups;

      expect(
        pickups.where((pickup) => pickup.kind == .plastic).length,
        5,
      );
      for (final location in GameLevel.level1.locations) {
        expect(
          count(
            pickups,
            location,
            .plastic,
          ),
          greaterThan(0),
          reason: location.name,
        );
      }
      expect(
        count(
              pickups,
              .dump,
              .cloth,
            ) +
            count(
              pickups,
              .lake,
              .cloth,
            ),
        3,
      );
      expect(
        count(
          pickups,
          .lake,
          .sand,
        ),
        3,
      );
      expect(
        count(
          pickups,
          .forest,
          .wood,
        ),
        6,
      );
      expect(
        pickups.where((pickup) => pickup.kind == .wood).length,
        6,
      );
      expect(
        count(
          pickups,
          .dump,
          .metal,
        ),
        5,
      );
      expect(
        count(
              pickups,
              .forest,
              .organics,
            ) +
            count(
              pickups,
              .dump,
              .organics,
            ),
        5,
      );
      expect(
        count(
          pickups,
          .lake,
          .cattail,
        ),
        4,
      );
      expect(
        count(
          pickups,
          .lake,
          .algae,
        ),
        4,
      );
      expect(
        count(
              pickups,
              .forest,
              .berryBush,
            ) +
            count(
              pickups,
              .house,
              .berryBush,
            ),
        4,
      );
    },
  );

  test(
    'gives every level 1 pickup a unique id',
    () {
      final pickups = (PickupRepositoryImpl()..startLevel(.level1)).pickups;

      expect(
        pickups.map((pickup) => pickup.id).toSet(),
        hasLength(pickups.length),
      );
    },
  );

  test(
    'has no resources on levels 2 and 3 yet',
    () {
      final repository = PickupRepositoryImpl()..startLevel(.level2);
      expect(
        repository.pickups,
        isEmpty,
      );

      repository.startLevel(.level3);
      expect(
        repository.pickups,
        isEmpty,
      );
    },
  );

  test(
    'collect removes only that pickup and emits the rest',
    () async {
      final repository = PickupRepositoryImpl()..startLevel(.level1);
      final emitted = <List<Pickup>>[];
      final subscription = repository.pickupsStream.listen(emitted.add);
      addTearDown(subscription.cancel);
      final first = repository.pickups.first;
      final total = repository.pickups.length;

      repository.collect(first);
      await pumpEventQueue();

      expect(
        repository.pickups,
        hasLength(total - 1),
      );
      expect(
        repository.pickups.any((pickup) => pickup.id == first.id),
        isFalse,
      );
      expect(
        emitted.single,
        hasLength(total - 1),
      );
    },
  );

  test(
    'starting the level again brings every pickup back',
    () {
      final repository = PickupRepositoryImpl()..startLevel(.level1);
      final total = repository.pickups.length;
      repository
        ..collect(repository.pickups.first)
        ..startLevel(.level1);

      expect(
        repository.pickups,
        hasLength(total),
      );
    },
  );

  test(
    'restore replaces the pickups',
    () {
      final repository = PickupRepositoryImpl()..startLevel(.level1);

      repository.restore(const [
        Pickup(
          id: 7,
          location: .lake,
          kind: .sand,
        ),
      ]);

      expect(
        repository.pickups.single.id,
        7,
      );
      expect(
        repository.pickups.single.kind,
        PickupKind.sand,
      );
    },
  );
}
