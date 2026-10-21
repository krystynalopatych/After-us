import 'dart:async';

import 'package:data/day/repository/day_repository_impl.dart';
import 'package:data/feedback/repository/feedback_repository_impl.dart';
import 'package:data/inventory/repository/inventory_repository_impl.dart';
import 'package:data/material/repository/material_repository_impl.dart';
import 'package:data/player/repository/meal_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:data/selection/repository/selection_repository_impl.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/water_bottle.dart';
import 'package:domain/inventory/model/water_request.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/inventory/use_case/lake_water_request_use_case.dart';
import 'package:domain/inventory/use_case/water_bottles_use_case.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DayRepositoryImpl day;
  late FeedbackRepositoryImpl feedback;
  late InventoryRepositoryImpl inventory;
  late MaterialRepositoryImpl material;
  late MealRepositoryImpl meal;
  late SelectionRepositoryImpl selection;
  late PlayerRepositoryImpl player;
  late PollutionRepositoryImpl pollution;
  late List<FeedbackMessage> messages;
  late StreamSubscription<FeedbackMessage> subscription;

  setUp(() {
    day = DayRepositoryImpl();
    feedback = FeedbackRepositoryImpl();
    inventory = InventoryRepositoryImpl();
    material = MaterialRepositoryImpl();
    meal = MealRepositoryImpl();
    selection = SelectionRepositoryImpl();
    player = PlayerRepositoryImpl()
      ..setStats(
        const .new(
          health: 50,
          hunger: 50,
          thirst: 50,
        ),
      );
    pollution = PollutionRepositoryImpl();
    messages = [];
    subscription = feedback.messageStream.listen(messages.add);
  });

  tearDown(() => subscription.cancel());

  group(
    'ConsumeUseCase',
    () {
      late ConsumeUseCase consume;

      setUp(
        () => consume = ConsumeUseCase(
          dayRepository: day,
          feedbackRepository: feedback,
          inventoryRepository: inventory,
          materialRepository: material,
          mealRepository: meal,
          playerRepository: player,
          pollutionRepository: pollution,
        ),
      );

      test(
        'drinking from a SODIS bottle gives the empty bottle back',
        () {
          inventory.add(.sodisStrainedWater);

          expect(
            consume(.sodisStrainedWater),
            isTrue,
          );
          expect(
            (player.stats.thirst, player.stats.health),
            (75.0, 45.0),
          );
          expect(
            inventory.count(.sodisBottle),
            1,
          );
        },
      );

      test(
        'drinking lake water from a plastic bottle gives the plastic back',
        () async {
          inventory.add(.bottleLakeWater);

          expect(
            consume(.bottleLakeWater),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            material.count(.plastic),
            1,
          );
          expect(
            messages.single.text,
            'You drank lake water +20 thirst −15 health +1 plastic',
          );
        },
      );

      test(
        'the third portion of the same food in a day gives half',
        () async {
          for (var i = 0; i < 3; i++) {
            inventory.add(.berries);
            consume(.berries);
          }
          await pumpEventQueue();

          expect(
            player.stats.hunger,
            closeTo(50 - 0 + 10 + 10 + 5, 0.001),
          );
          expect(
            messages.last.text,
            'You ate berries +5 hunger +1.5 thirst\nThe same food again only half as filling',
          );
        },
      );

      test(
        'raw and cooked food and water are counted apart, a new day starts over',
        () {
          for (var i = 0; i < 2; i++) {
            inventory
              ..add(.cattailRoot)
              ..add(.cleanWater)
              ..add(.cleanWater);
            consume(.cattailRoot);
            consume(.cleanWater);
            consume(.cleanWater);
          }
          inventory.add(.cattailRootCooked);
          final hunger = player.stats.hunger;
          consume(.cattailRootCooked);

          expect(
            player.stats.hunger - hunger,
            20,
          );
          expect(
            meal.meals.countOn(
              1,
              .cleanWater,
            ),
            0,
          );

          day.setDay(
            const GameDay(
              number: 2,
              seconds: 0,
            ),
          );
          inventory.add(.cattailRoot);
          final dayTwoHunger = player.stats.hunger;
          consume(.cattailRoot);

          expect(
            player.stats.hunger - dayTwoHunger,
            10,
          );
        },
      );

      test(
        'every food and drink gives its values and is removed',
        () {
          final expected = {
            InventoryItem.berries: (60.0, 53.0, 50.0),
            InventoryItem.algae: (54.0, 50.0, 50.0),
            InventoryItem.algaeSoaked: (60.0, 50.0, 50.0),
            InventoryItem.cattailRoot: (60.0, 50.0, 50.0),
            InventoryItem.cattailRootCooked: (70.0, 50.0, 50.0),
            InventoryItem.cleanWater: (50.0, 85.0, 50.0),
            InventoryItem.sodisLakeWater: (50.0, 70.0, 35.0),
            InventoryItem.bottleLakeWater: (50.0, 70.0, 35.0),
          };
          for (final MapEntry(key: item, value: (hunger, thirst, health)) in expected.entries) {
            player.setStats(
              const .new(
                health: 50,
                hunger: 50,
                thirst: 50,
              ),
            );
            inventory.add(item);

            expect(
              consume(item),
              isTrue,
            );
            expect(
              (player.stats.hunger, player.stats.thirst, player.stats.health),
              (hunger, thirst, health),
              reason: item.name,
            );
            expect(
              inventory.count(item),
              0,
            );
          }
        },
      );

      test(
        'tools and missing items are not consumed',
        () {
          inventory.add(.cookingPot);

          expect(
            consume(.cookingPot),
            isFalse,
          );
          expect(
            consume(.berries),
            isFalse,
          );
          expect(
            inventory.count(.cookingPot),
            1,
          );
          expect(
            player.stats,
            const PlayerStats(
              health: 50,
              hunger: 50,
              thirst: 50,
            ),
          );
        },
      );

      test(
        'stats are clamped to 100 and health to the ceiling',
        () {
          player.setStats(
            const .new(
              health: 10,
              hunger: 95,
              thirst: 90,
              healthCeiling: 80,
            ),
          );
          inventory
            ..add(.cattailRootCooked)
            ..add(.cleanWater)
            ..add(.sodisLakeWater);
          consume(.cattailRootCooked);
          consume(.cleanWater);
          consume(.sodisLakeWater);

          expect(
            player.stats.hunger,
            100,
          );
          expect(
            player.stats.thirst,
            100,
          );
          expect(
            player.stats.health,
            0,
          );
        },
      );

      test(
        'polluted water halves lake food and water and costs 10 health',
        () {
          pollution.polluteWater();
          inventory
            ..add(.cattailRoot)
            ..add(.sodisLakeWater)
            ..add(.berries);
          consume(.cattailRoot);

          expect(
            (player.stats.hunger, player.stats.health),
            (55.0, 40.0),
          );

          consume(.sodisLakeWater);

          expect(
            (player.stats.thirst, player.stats.health),
            (60.0, 15.0),
          );

          consume(.berries);

          expect(
            (player.stats.hunger, player.stats.thirst, player.stats.health),
            (65.0, 63.0, 15.0),
          );
        },
      );

      test(
        'polluted soil halves berries and costs 40 health',
        () {
          pollution.polluteSoil();
          inventory
            ..add(.berries)
            ..add(.algae);
          consume(.berries);

          expect(
            (player.stats.hunger, player.stats.thirst, player.stats.health),
            (55.0, 51.5, 10.0),
          );

          consume(.algae);

          expect(
            (player.stats.hunger, player.stats.health),
            (59.0, 10.0),
          );
        },
      );

      test(
        'shows a message for each item',
        () async {
          inventory
            ..add(.berries)
            ..add(.sodisLakeWater)
            ..add(.cattailRoot);
          consume(.berries);
          consume(.sodisLakeWater);
          pollution.polluteWater();
          consume(.cattailRoot);
          await pumpEventQueue();

          expect(
            messages,
            const [
              FeedbackMessage(
                text: 'You ate berries +10 hunger +3 thirst',
                mood: .happy,
              ),
              FeedbackMessage(
                text: 'You drank lake water +20 thirst −15 health',
                heroLine: 'It tastes like mud. I need clean water.',
                mood: .sad,
              ),
              FeedbackMessage(
                text: 'You ate cattail roots from the polluted lake +5 hunger −10 health',
                heroLine: 'Ugh... The lake is poisoned now.',
                mood: .sad,
              ),
            ],
          );
        },
      );

      test(
        'polluted soil message shows halved decimals',
        () async {
          pollution.polluteSoil();
          inventory.add(.berries);
          consume(.berries);
          await pumpEventQueue();

          expect(
            messages.single.text,
            'You ate berries from polluted soil +5 hunger +1.5 thirst −40 health',
          );
        },
      );
    },
  );

  group(
    'FillBottleUseCase',
    () {
      late FillBottleUseCase fill;

      setUp(
        () => fill = FillBottleUseCase(
          feedbackRepository: feedback,
          inventoryRepository: inventory,
          materialRepository: material,
          selectionRepository: selection,
        ),
      );

      test(
        'needs the chosen bottle',
        () async {
          expect(
            fill(
              .sodis,
              .lake,
            ),
            isFalse,
          );
          expect(
            fill(
              .plastic,
              .lake,
            ),
            isFalse,
          );
          await pumpEventQueue();

          expect(
            messages.map((message) => message.text),
            ['You have no empty SODIS bottle', 'You have no plastic bottle'],
          );
        },
      );

      test(
        'a SODIS bottle holds one water and becomes busy',
        () async {
          inventory.add(.sodisBottle);
          selection.selectSlot(0);

          expect(
            fill(
              .sodis,
              .lake,
            ),
            isTrue,
          );
          expect(
            fill(
              .sodis,
              .lake,
            ),
            isFalse,
          );
          await pumpEventQueue();

          expect(
            inventory.count(.sodisLakeWater),
            1,
          );
          expect(
            inventory.count(.sodisBottle),
            0,
          );
          expect(
            selection.selection.slot,
            isNull,
          );
          expect(
            messages.map((message) => message.text),
            ['You filled a SODIS bottle with lake water', 'You have no empty SODIS bottle'],
          );
        },
      );

      test(
        'a plastic bottle takes one plastic from the counter',
        () async {
          material
            ..add(.plastic)
            ..add(.plastic);
          selection.selectMaterial(.plastic);

          expect(
            fill(
              .plastic,
              .lake,
            ),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            inventory.count(.bottleLakeWater),
            1,
          );
          expect(
            material.count(.plastic),
            1,
          );
          expect(
            selection.selection.material,
            GameMaterial.plastic,
          );
          expect(
            messages.single.text,
            'You filled a plastic bottle with lake water',
          );

          fill(
            .plastic,
            .lake,
          );

          expect(
            material.count(.plastic),
            0,
          );
          expect(
            selection.selection.material,
            isNull,
          );
        },
      );

      test(
        'strained and filtered water go into the chosen bottle',
        () {
          inventory.add(.sodisBottle);
          material.add(.plastic);

          fill(
            .sodis,
            .strained,
          );
          fill(
            .plastic,
            .filtered,
          );

          expect(
            inventory.count(.sodisStrainedWater),
            1,
          );
          expect(
            inventory.count(.bottleFilteredWater),
            1,
          );
        },
      );

      test(
        'a full inventory takes no water',
        () async {
          for (var i = 0; i < 60; i++) {
            inventory.add(.berries);
          }
          material.add(.plastic);

          expect(
            fill(
              .plastic,
              .lake,
            ),
            isFalse,
          );
          await pumpEventQueue();

          expect(
            material.count(.plastic),
            1,
          );
          expect(
            messages.last.text,
            'Your inventory is full',
          );
        },
      );
    },
  );

  group(
    'LakeWaterRequestUseCase',
    () {
      late LakeWaterRequestUseCase request;

      setUp(
        () => request = LakeWaterRequestUseCase(
          feedbackRepository: feedback,
          inventoryRepository: inventory,
          selectionRepository: selection,
        ),
      );

      test(
        'plastic and SODIS fill lake water right away',
        () {
          inventory.add(.sodisBottle);

          selection.selectMaterial(.plastic);
          expect(
            request(),
            const WaterRequest(
              water: .lake,
              bottle: .plastic,
            ),
          );

          selection.selectSlot(0);
          expect(
            request(),
            const WaterRequest(
              water: .lake,
              bottle: .sodis,
            ),
          );
        },
      );

      test(
        'filters ask where to store the water',
        () {
          inventory
            ..add(.prefilter)
            ..add(.waterFilter);

          selection.selectSlot(0);
          expect(
            request(),
            const WaterRequest(water: .strained),
          );

          selection.selectSlot(1);
          expect(
            request(),
            const WaterRequest(water: .filtered),
          );
        },
      );

      test(
        'anything else asks for a bottle',
        () async {
          inventory.add(.berries);
          selection.selectSlot(0);

          expect(
            request(),
            isNull,
          );
          selection.reset();
          expect(
            request(),
            isNull,
          );
          await pumpEventQueue();

          expect(
            messages.map((message) => message.text),
            ['Choose a bottle to fill', 'Choose a bottle to fill'],
          );
        },
      );
    },
  );

  group(
    'WaterBottlesUseCase',
    () {
      test(
        'offers only the bottles the player has',
        () {
          final bottles = WaterBottlesUseCase(
            inventoryRepository: inventory,
            materialRepository: material,
          );

          expect(
            bottles(),
            isEmpty,
          );

          inventory.add(.sodisBottle);
          material.add(.plastic);

          expect(
            bottles(),
            {WaterBottle.sodis, WaterBottle.plastic},
          );
        },
      );
    },
  );
}
