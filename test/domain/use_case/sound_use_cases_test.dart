import 'package:domain/compost/model/compost_pit.dart';
import 'package:domain/compost/use_case/use_compost_pit_use_case.dart';
import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:domain/pickup/use_case/keep_pickup_use_case.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/sound/model/game_sound.dart';
import 'package:domain/sound/use_case/hero_voice_use_case.dart';
import 'package:domain/sound/use_case/mute_sound_use_case.dart';
import 'package:domain/sound/use_case/play_message_sound_use_case.dart';
import 'package:domain/sound/use_case/stop_music_use_case.dart';
import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:domain/sun_spot/use_case/use_sun_spot_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  group(
    'PlayMessageSoundUseCase',
    () {
      test(
        'plays the message sound only for sad messages',
        () {
          final playMessageSound = diContainer.get<PlayMessageSoundUseCase>();

          playMessageSound(const FeedbackMessage(text: 'Not enough materials'));
          playMessageSound(
            const FeedbackMessage(
              text: 'You crafted a SODIS bottle',
              mood: .happy,
            ),
          );
          expect(
            deps.sound.played,
            isEmpty,
          );

          playMessageSound(
            const FeedbackMessage(
              text: 'The air is dirty max health −5',
              mood: .sad,
            ),
          );
          expect(
            deps.sound.played,
            [GameSound.message],
          );
        },
      );
    },
  );

  group(
    'HeroVoiceUseCase',
    () {
      test(
        'loops the voice while the hero speaks and stops it after',
        () {
          final heroVoice = diContainer.get<HeroVoiceUseCase>();

          heroVoice(true);
          expect(
            deps.sound.looping,
            {GameSound.speak},
          );

          heroVoice(false);
          expect(
            deps.sound.looping,
            isEmpty,
          );
        },
      );
    },
  );

  group(
    'background music',
    () {
      test(
        'starts with the level',
        () {
          diContainer.get<StartLevelUseCase>()(.level1);

          expect(
            deps.sound.looping,
            {GameSound.backgroundMusic},
          );
        },
      );

      test(
        'stops when the level is over',
        () {
          diContainer.get<StartLevelUseCase>()(.level1);
          deps.player.setStats(
            const PlayerStats(
              health: 0,
              hunger: 0,
              thirst: 0,
            ),
          );

          diContainer.get<PassSecondUseCase>()(.level1);

          expect(
            deps.day.outcome,
            isNotNull,
          );
          expect(
            deps.sound.looping,
            isEmpty,
          );
          expect(
            deps.sound.played,
            [GameSound.lose],
          );
        },
      );

      test(
        'keeps playing while the level goes on',
        () {
          diContainer.get<StartLevelUseCase>()(.level1);

          diContainer.get<PassSecondUseCase>()(.level1);

          expect(
            deps.sound.looping,
            {GameSound.backgroundMusic},
          );
        },
      );

      test(
        'stops when the player leaves the level',
        () {
          diContainer.get<StartLevelUseCase>()(.level1);

          diContainer.get<StopMusicUseCase>()();

          expect(
            deps.sound.looping,
            isEmpty,
          );
        },
      );
    },
  );

  group(
    'eating sound',
    () {
      test(
        'plays when the hero eats',
        () {
          deps.inventory.add(.berries);

          expect(
            diContainer.get<ConsumeUseCase>()(.berries),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.eating],
          );
        },
      );

      test(
        'does not play when the hero drinks or has nothing to eat',
        () {
          final consume = diContainer.get<ConsumeUseCase>();
          deps.inventory.add(.sodisCleanWater);

          expect(
            consume(.sodisCleanWater),
            isTrue,
          );
          expect(
            consume(.berries),
            isFalse,
          );
          expect(
            deps.sound.played,
            isEmpty,
          );
        },
      );
    },
  );

  group(
    'pick up sound',
    () {
      test(
        'plays when a pickup is kept',
        () {
          deps.pickup.startLevel(.level1);
          final plastic = deps.pickup.pickups.firstWhere((pickup) => pickup.kind == PickupKind.plastic);

          expect(
            diContainer.get<KeepPickupUseCase>()(plastic),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.pickUp],
          );
        },
      );

      test(
        'does not play when the inventory has no room for the pickup',
        () {
          deps.pickup.startLevel(.level1);
          for (var i = 0; i < 60; i++) {
            deps.inventory.add(.cookingPot);
          }
          final food = deps.pickup.pickups.firstWhere((pickup) => pickup.kind.food != null);

          expect(
            diContainer.get<KeepPickupUseCase>()(food),
            isFalse,
          );
          expect(
            deps.sound.played,
            isEmpty,
          );
        },
      );

      test(
        'plays when something is crafted and not when crafting fails',
        () {
          final craft = diContainer.get<CraftUseCase>();

          expect(
            craft(const [null, WorkbenchItem.material(.plastic), null, null]),
            isFalse,
          );
          expect(
            deps.sound.played,
            isEmpty,
          );

          deps.material.add(.plastic);
          expect(
            craft(const [null, WorkbenchItem.material(.plastic), null, null]),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.pickUp],
          );
        },
      );

      test(
        'plays when the algae are soaked',
        () {
          deps.inventory
            ..add(.algae)
            ..add(.sodisCleanWater);

          expect(
            diContainer.get<CraftUseCase>()(
              const [WorkbenchItem.item(.algae), WorkbenchItem.item(.sodisCleanWater), null, null],
            ),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.pickUp],
          );
        },
      );

      test(
        'plays when food is cooked on the campfire',
        () {
          deps.inventory
            ..add(.cookingPot)
            ..add(.cattailRoot);
          deps.material.add(.wood);

          expect(
            diContainer.get<CookOnCampfireUseCase>()(
              .cookCattailRoot,
              .wood,
              .campfire,
            ),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.pickUp],
          );
        },
      );

      test(
        'plays when a bottle is filled and not when there is no bottle',
        () {
          final fill = diContainer.get<FillBottleUseCase>();

          expect(
            fill(
              .sodis,
              .lake,
            ),
            isFalse,
          );
          expect(
            deps.sound.played,
            isEmpty,
          );

          deps.inventory.add(.sodisBottle);
          expect(
            fill(
              .sodis,
              .lake,
            ),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.pickUp],
          );
        },
      );

      test(
        'plays when the SODIS bottle is taken from the sun, not when it is left there',
        () {
          final useSunSpot = diContainer.get<UseSunSpotUseCase>();
          deps.inventory.add(.sodisStrainedWater);
          deps.selection.selectSlot(0);

          expect(
            useSunSpot(),
            isTrue,
          );
          expect(
            deps.sound.played,
            isEmpty,
          );

          deps.sunSpot.restore(
            const SunBottle(
              item: .sodisStrainedWater,
              seconds: SunBottle.readySeconds,
            ),
          );
          expect(
            useSunSpot(),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.pickUp],
          );
        },
      );

      test(
        'plays when the compost is taken, not when organics go in',
        () {
          final useCompostPit = diContainer.get<UseCompostPitUseCase>();
          deps.material.add(.organics);
          deps.selection.selectMaterial(.organics);

          expect(
            useCompostPit(),
            isTrue,
          );
          expect(
            deps.sound.played,
            isEmpty,
          );

          deps.compost.restore(
            const CompostPit(
              organics: CompostPit.capacity,
              seconds: CompostPit.readySeconds,
            ),
          );
          expect(
            useCompostPit(),
            isTrue,
          );
          expect(
            deps.sound.played,
            [GameSound.pickUp],
          );
        },
      );
    },
  );

  test(
    'MuteSoundUseCase mutes and unmutes the sound',
    () async {
      final muteSound = diContainer.get<MuteSoundUseCase>();
      final changes = <bool>[];
      final subscription = deps.sound.isMutedStream.listen(changes.add);
      addTearDown(subscription.cancel);

      muteSound(true);
      expect(
        deps.sound.isMuted,
        isTrue,
      );
      muteSound(false);
      expect(
        deps.sound.isMuted,
        isFalse,
      );
      await pumpEventQueue();
      expect(
        changes,
        [true, false],
      );
    },
  );
}
