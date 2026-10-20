import 'dart:async';

import 'package:data/feedback/repository/feedback_repository_impl.dart';
import 'package:data/inventory/repository/inventory_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FeedbackRepositoryImpl feedback;
  late InventoryRepositoryImpl inventory;
  late PlayerRepositoryImpl player;
  late PollutionRepositoryImpl pollution;
  late List<FeedbackMessage> messages;
  late StreamSubscription<FeedbackMessage> subscription;

  setUp(() {
    feedback = FeedbackRepositoryImpl();
    inventory = InventoryRepositoryImpl();
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
          feedbackRepository: feedback,
          inventoryRepository: inventory,
          playerRepository: player,
          pollutionRepository: pollution,
        ),
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
            InventoryItem.lakeWater: (50.0, 70.0, 35.0),
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
            ..add(.lakeWater);
          consume(.cattailRootCooked);
          consume(.cleanWater);
          consume(.lakeWater);

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
            ..add(.lakeWater)
            ..add(.berries);
          consume(.cattailRoot);

          expect(
            (player.stats.hunger, player.stats.health),
            (55.0, 40.0),
          );

          consume(.lakeWater);

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
            ..add(.lakeWater)
            ..add(.cattailRoot);
          consume(.berries);
          consume(.lakeWater);
          pollution.polluteWater();
          consume(.cattailRoot);
          await pumpEventQueue();

          expect(
            messages,
            const [
              FeedbackMessage(
                text: 'You ate berries. +10 hunger, +3 thirst.',
                mood: .happy,
              ),
              FeedbackMessage(
                text: 'You drank lake water. +20 thirst, −15 health.',
                heroLine: 'It tastes like mud. I need clean water.',
                mood: .sad,
              ),
              FeedbackMessage(
                text: 'You ate cattail roots from the polluted lake. +5 hunger, −10 health.',
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
            'You ate berries from polluted soil. +5 hunger, +1.5 thirst, −40 health.',
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
        ),
      );

      test(
        'needs a SODIS bottle',
        () async {
          expect(
            fill(),
            isFalse,
          );
          await pumpEventQueue();

          expect(
            inventory.count(.lakeWater),
            0,
          );
          expect(
            messages.single.text,
            'You need a SODIS bottle to carry lake water.',
          );
        },
      );

      test(
        'adds lake water and keeps the bottle',
        () async {
          inventory.add(.sodisBottle);

          expect(
            fill(),
            isTrue,
          );
          expect(
            fill(),
            isTrue,
          );
          await pumpEventQueue();

          expect(
            inventory.count(.lakeWater),
            2,
          );
          expect(
            inventory.count(.sodisBottle),
            1,
          );
          expect(
            messages.last.text,
            'You filled a bottle with lake water.',
          );
        },
      );

      test(
        'a full inventory takes no water',
        () async {
          for (var i = 0; i < 60; i++) {
            inventory.add(.sodisBottle);
          }

          expect(
            fill(),
            isFalse,
          );
          await pumpEventQueue();

          expect(
            messages.last.text,
            'Your inventory is full.',
          );
        },
      );
    },
  );
}
