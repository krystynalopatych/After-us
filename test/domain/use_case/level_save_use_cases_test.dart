import 'package:domain/character/model/character_mood.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/station/model/station.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late StartLevelUseCase startLevel;
  late SaveGameUseCase saveGame;

  setUp(() {
    deps = TestDependencies();
    startLevel = StartLevelUseCase(
      campfireRepository: deps.campfire,
      compostRepository: deps.compost,
      characterRepository: deps.character,
      clockRepository: deps.clock,
      constructionRepository: deps.construction,
      dayRepository: deps.day,
      inventoryRepository: deps.inventory,
      locationRepository: deps.location,
      materialRepository: deps.material,
      mealRepository: deps.meal,
      pickupRepository: deps.pickup,
      playerRepository: deps.player,
      pollutionRepository: deps.pollution,
      saveRepository: deps.save,
      selectionRepository: deps.selection,
      stationRepository: deps.station,
      sunSpotRepository: deps.sunSpot,
    );
    saveGame = SaveGameUseCase(
      campfireRepository: deps.campfire,
      compostRepository: deps.compost,
      constructionRepository: deps.construction,
      dayRepository: deps.day,
      inventoryRepository: deps.inventory,
      locationRepository: deps.location,
      materialRepository: deps.material,
      mealRepository: deps.meal,
      pickupRepository: deps.pickup,
      playerRepository: deps.player,
      pollutionRepository: deps.pollution,
      saveRepository: deps.save,
      stationRepository: deps.station,
      sunSpotRepository: deps.sunSpot,
    );
  });

  GameSave save(GameLevel level) => GameSave(
    level: level,
    location: .lake,
    savedAt: DateTime(
      2026,
      10,
      20,
    ),
    day: const GameDay(
      number: 2,
      seconds: 100,
    ),
    stats: const PlayerStats(
      health: 60,
      hunger: 30,
      thirst: 20,
      healthCeiling: 90,
    ),
    materials: const [
      MaterialStock(
        material: .sand,
        count: 2,
      ),
    ],
    inventory: const [
      InventoryStack(
        item: .algae,
        count: 4,
      ),
    ],
    pickups: const [
      Pickup(
        id: 3,
        location: .lake,
        kind: .cattail,
      ),
    ],
    pollution: const Pollution(
      airPoints: 5,
      isWaterPolluted: true,
      isSoilPolluted: true,
    ),
    constructions: const {.waterFilter},
    stations: const {.workbench},
  );

  group(
    'StartLevelUseCase',
    () {
      test(
        'a new level resets every repository and lays out its pickups',
        () {
          deps.character.setMood(.sad);
          deps.day.setOutcome(.died);
          deps.material.add(.metal);
          deps.construction.build(.compostPit);
          deps.station.build(.campfire);
          deps.selection.selectMaterial(.wood);
          deps.location.setLocation(.dump);

          startLevel(.level1);

          expect(
            deps.character.mood,
            CharacterMood.normal,
          );
          expect(
            deps.day.day,
            const GameDay.first(),
          );
          expect(
            deps.day.outcome,
            isNull,
          );
          expect(
            deps.material.stocks,
            isEmpty,
          );
          expect(
            deps.construction.built,
            isEmpty,
          );
          expect(
            deps.station.built,
            isEmpty,
          );
          expect(
            deps.selection.selection.material,
            isNull,
          );
          expect(
            deps.location.location,
            GameLocation.house,
          );
          expect(
            deps.pickup.pickups,
            hasLength(39),
          );
        },
      );

      test(
        'a loaded save for the level restores every repository once',
        () {
          deps.save.load(save(.level1));

          startLevel(.level1);

          expect(
            deps.day.day,
            const GameDay(
              number: 2,
              seconds: 100,
            ),
          );
          expect(
            deps.player.stats.healthCeiling,
            90,
          );
          expect(
            deps.material.count(.sand),
            2,
          );
          expect(
            deps.inventory.count(.algae),
            4,
          );
          expect(
            deps.pickup.pickups.single.id,
            3,
          );
          expect(
            deps.pollution.pollution.airPoints,
            5,
          );
          expect(
            deps.construction.built,
            {Construction.waterFilter},
          );
          expect(
            deps.station.built,
            {Station.workbench},
          );
          expect(
            deps.location.location,
            GameLocation.lake,
          );
          expect(
            deps.save.takeLoadedSave(),
            isNull,
          );
        },
      );

      test(
        'a save for another level is ignored',
        () {
          deps.save.load(save(.level2));

          startLevel(.level1);

          expect(
            deps.location.location,
            GameLocation.house,
          );
          expect(
            deps.pickup.pickups,
            hasLength(39),
          );
        },
      );
    },
  );

  test(
    'SaveGameUseCase stores a full snapshot of the game',
    () {
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
      deps.construction.build(.rocketStove);
      deps.station.build(.campfire);

      saveGame(.level1);

      final saved = deps.save.saves.single;
      expect(
        saved.level,
        GameLevel.level1,
      );
      expect(
        saved.location,
        GameLocation.forest,
      );
      expect(
        saved.day,
        const GameDay(
          number: 2,
          seconds: 50,
        ),
      );
      expect(
        saved.stats.health,
        77,
      );
      expect(
        saved.materials.single.material,
        GameMaterial.wood,
      );
      expect(
        saved.inventory.single.item,
        InventoryItem.berries,
      );
      expect(
        saved.pickups,
        hasLength(39),
      );
      expect(
        saved.pollution.airPoints,
        2,
      );
      expect(
        saved.constructions,
        {Construction.rocketStove},
      );
      expect(
        saved.stations,
        {Station.campfire},
      );
    },
  );
}
