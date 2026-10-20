import 'dart:async';

import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/progress/model/game_level.dart';

final class PickupRepositoryImpl implements PickupRepository {
  static const _level1 = <(GameLocation, PickupKind)>[
    (.house, .plastic),
    (.house, .berryBush),
    (.house, .berryBush),
    (.forest, .plastic),
    (.forest, .wood),
    (.forest, .wood),
    (.forest, .wood),
    (.forest, .wood),
    (.forest, .wood),
    (.forest, .wood),
    (.forest, .organics),
    (.forest, .organics),
    (.forest, .organics),
    (.forest, .berryBush),
    (.forest, .berryBush),
    (.lake, .plastic),
    (.lake, .cloth),
    (.lake, .sand),
    (.lake, .sand),
    (.lake, .sand),
    (.lake, .cattail),
    (.lake, .cattail),
    (.lake, .cattail),
    (.lake, .cattail),
    (.lake, .algae),
    (.lake, .algae),
    (.lake, .algae),
    (.lake, .algae),
    (.dump, .plastic),
    (.dump, .plastic),
    (.dump, .cloth),
    (.dump, .cloth),
    (.dump, .metal),
    (.dump, .metal),
    (.dump, .metal),
    (.dump, .metal),
    (.dump, .metal),
    (.dump, .organics),
    (.dump, .organics),
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
      .level2 || .level3 => const <(GameLocation, PickupKind)>[],
    };
    _pickups
      ..clear()
      ..addAll([
        for (final (index, (location, kind)) in layout.indexed)
          Pickup(
            id: index,
            location: location,
            kind: kind,
          ),
      ]);
    _pickupsController.add(pickups);
  }

  @override
  void collect(Pickup pickup) {
    _pickups.removeWhere((item) => item.id == pickup.id);
    _pickupsController.add(pickups);
  }

  @override
  void restore(List<Pickup> pickups) {
    _pickups
      ..clear()
      ..addAll(pickups);
    _pickupsController.add(this.pickups);
  }
}
