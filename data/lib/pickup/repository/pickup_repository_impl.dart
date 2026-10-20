import 'dart:async';

import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/progress/model/game_level.dart';

final class PickupRepositoryImpl implements PickupRepository {
  static const _level1 = <(GameLocation, PickupKind, double, double)>[
    (.house, .plastic, 700, 560),
    (.house, .berryBush, 180, 600),
    (.house, .berryBush, 820, 160),
    (.forest, .plastic, 1050, 900),
    (.forest, .wood, 520, 300),
    (.forest, .wood, 760, 200),
    (.forest, .wood, 1100, 260),
    (.forest, .wood, 1380, 420),
    (.forest, .wood, 600, 700),
    (.forest, .wood, 1250, 760),
    (.forest, .organics, 900, 520),
    (.forest, .organics, 1500, 620),
    (.forest, .organics, 560, 900),
    (.forest, .berryBush, 340, 480),
    (.forest, .berryBush, 1560, 280),
    (.lake, .plastic, 1500, 960),
    (.lake, .cloth, 1700, 760),
    (.lake, .sand, 480, 850),
    (.lake, .sand, 600, 950),
    (.lake, .sand, 1320, 900),
    (.lake, .cattail, 180, 420),
    (.lake, .cattail, 400, 170),
    (.lake, .cattail, 1560, 240),
    (.lake, .cattail, 1600, 520),
    (.lake, .algae, 340, 700),
    (.lake, .algae, 200, 600),
    (.lake, .algae, 1300, 780),
    (.lake, .algae, 1460, 760),
    (.dump, .plastic, 900, 400),
    (.dump, .plastic, 600, 900),
    (.dump, .cloth, 1100, 300),
    (.dump, .cloth, 480, 800),
    (.dump, .metal, 520, 330),
    (.dump, .metal, 820, 240),
    (.dump, .metal, 1000, 560),
    (.dump, .metal, 700, 720),
    (.dump, .metal, 1180, 760),
    (.dump, .organics, 760, 500),
    (.dump, .organics, 1240, 640),
  ];

  final _pickupsController = StreamController<List<Pickup>>.broadcast();
  final _pickups = <Pickup>[];

  @override
  List<Pickup> get pickups => List.unmodifiable(_pickups);

  @override
  Stream<List<Pickup>> get pickupsStream => _pickupsController.stream;

  @override
  void startLevel(GameLevel level) {
    final layout = switch (level) {
      .level1 => _level1,
      .level2 || .level3 => const <(GameLocation, PickupKind, double, double)>[],
    };
    _pickups
      ..clear()
      ..addAll([
        for (final (index, (location, kind, left, top)) in layout.indexed)
          Pickup(id: index, location: location, kind: kind, left: left, top: top),
      ]);
    _pickupsController.add(pickups);
  }

  @override
  void collect(Pickup pickup) {
    _pickups.removeWhere((item) => item.id == pickup.id);
    _pickupsController.add(pickups);
  }
}
