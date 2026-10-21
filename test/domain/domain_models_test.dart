import 'package:domain/day/model/game_day.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/pollution/model/air_quality.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Pollution withAir(int points) => Pollution(
    airPoints: points,
    isWaterPolluted: false,
    isSoilPolluted: false,
  );

  group(
    'Pollution',
    () {
      test(
        'starts clean',
        () {
          const pollution = Pollution.clean();

          expect(
            pollution.airPoints,
            0,
          );
          expect(
            pollution.isWaterPolluted,
            isFalse,
          );
          expect(
            pollution.isSoilPolluted,
            isFalse,
          );
          expect(
            pollution.airQuality,
            AirQuality.clean,
          );
        },
      );

      test(
        'air quality turns smoky from 1 point and polluted from 4 points',
        () {
          expect(
            withAir(0).airQuality,
            AirQuality.clean,
          );
          expect(
            withAir(1).airQuality,
            AirQuality.smoky,
          );
          expect(
            withAir(3).airQuality,
            AirQuality.smoky,
          );
          expect(
            withAir(4).airQuality,
            AirQuality.polluted,
          );
          expect(
            withAir(20).airQuality,
            AirQuality.polluted,
          );
        },
      );

      test(
        'daily health ceiling drop follows the design doc table',
        () {
          expect(
            withAir(0).dailyHealthCeilingDrop,
            0,
          );
          expect(
            withAir(1).dailyHealthCeilingDrop,
            5,
          );
          expect(
            withAir(3).dailyHealthCeilingDrop,
            5,
          );
          expect(
            withAir(4).dailyHealthCeilingDrop,
            10,
          );
          expect(
            withAir(7).dailyHealthCeilingDrop,
            10,
          );
          expect(
            withAir(8).dailyHealthCeilingDrop,
            20,
          );
          expect(
            withAir(30).dailyHealthCeilingDrop,
            20,
          );
        },
      );
    },
  );

  test(
    'GameMaterial air points follow the burn table, organics are harmless, the rest default to 1',
    () {
      expect(
        GameMaterial.plastic.airPoints,
        3,
      );
      expect(
        GameMaterial.cloth.airPoints,
        2,
      );
      expect(
        GameMaterial.oil.airPoints,
        3,
      );
      expect(
        GameMaterial.electronics.airPoints,
        5,
      );
      expect(
        GameMaterial.organics.airPoints,
        0,
      );
      for (final material in [
        GameMaterial.sand,
        GameMaterial.wood,
        GameMaterial.metal,
        GameMaterial.cardboard,
        GameMaterial.seeds,
        GameMaterial.clay,
        GameMaterial.chlorine,
      ]) {
        expect(
          material.airPoints,
          1,
          reason: material.name,
        );
      }
    },
  );

  test(
    'GameMaterial pollutes water and soil only for the listed materials',
    () {
      expect(
        GameMaterial.values.where((material) => material.pollutesWater),
        [GameMaterial.plastic, GameMaterial.metal, GameMaterial.oil, GameMaterial.chlorine, GameMaterial.electronics],
      );
      expect(
        GameMaterial.values.where((material) => material.pollutesSoil),
        [GameMaterial.oil, GameMaterial.chlorine, GameMaterial.electronics],
      );
    },
  );

  test(
    'GameLocation marks only the far zones as far',
    () {
      expect(
        GameLocation.dump.isFar,
        isTrue,
      );
      expect(
        GameLocation.store.isFar,
        isTrue,
      );
      expect(
        GameLocation.garage.isFar,
        isTrue,
      );
      expect(
        GameLocation.house.isFar,
        isFalse,
      );
      expect(
        GameLocation.forest.isFar,
        isFalse,
      );
      expect(
        GameLocation.lake.isFar,
        isFalse,
      );
    },
  );

  group(
    'GameLevel',
    () {
      test(
        'has the days from the design doc',
        () {
          expect(
            GameLevel.level1.days,
            3,
          );
          expect(
            GameLevel.level2.days,
            4,
          );
          expect(
            GameLevel.level3.days,
            5,
          );
        },
      );

      test(
        'keeps home, forest and lake and swaps the far zone',
        () {
          expect(
            GameLevel.level1.locations,
            [GameLocation.house, GameLocation.forest, GameLocation.lake, GameLocation.dump],
          );
          expect(
            GameLevel.level2.locations.last,
            GameLocation.store,
          );
          expect(
            GameLevel.level3.locations.last,
            GameLocation.garage,
          );
        },
      );
    },
  );

  test(
    'PickupKind gives either a material or a food',
    () {
      expect(
        PickupKind.plastic.material,
        GameMaterial.plastic,
      );
      expect(
        PickupKind.wood.material,
        GameMaterial.wood,
      );
      expect(
        PickupKind.cattail.food,
        InventoryItem.cattailRoot,
      );
      expect(
        PickupKind.algae.food,
        InventoryItem.algae,
      );
      expect(
        PickupKind.berryBush.food,
        InventoryItem.berries,
      );
      for (final kind in PickupKind.values) {
        expect(
          (kind.material == null) != (kind.food == null),
          isTrue,
          reason: kind.name,
        );
      }
    },
  );

  test(
    'PlayerStats and GameDay start values match the design doc',
    () {
      const stats = PlayerStats.initial();
      const day = GameDay.first();

      expect(
        stats.health,
        100,
      );
      expect(
        stats.hunger,
        80,
      );
      expect(
        stats.thirst,
        80,
      );
      expect(
        stats.healthCeiling,
        100,
      );
      expect(
        day.number,
        1,
      );
      expect(
        day.seconds,
        0,
      );
      expect(
        GameDay.secondsPerDay,
        600,
      );
    },
  );

  test(
    'GameDay is over after ten minutes',
    () {
      expect(
        const GameDay(
          number: 1,
          seconds: 599,
        ).isOver,
        isFalse,
      );
      expect(
        const GameDay(
          number: 1,
          seconds: 600,
        ).isOver,
        isTrue,
      );
    },
  );

  test(
    'copyWith changes only the given fields',
    () {
      const stats = PlayerStats.initial();
      const day = GameDay.first();

      expect(
        stats.copyWith(thirst: 10),
        const PlayerStats(
          health: 100,
          hunger: 80,
          thirst: 10,
        ),
      );
      expect(
        stats.copyWith(healthCeiling: 70).healthCeiling,
        70,
      );
      expect(
        day.copyWith(seconds: 5),
        const GameDay(
          number: 1,
          seconds: 5,
        ),
      );
    },
  );
}
