import 'package:domain/book/model/book_record.dart';
import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/use_case/level_intro_use_case.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/use_case/eat_seeds_use_case.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/di/di_container.dart';
import 'package:presentation/feature/hud/bloc/hud_bloc.dart';
import 'package:presentation/feature/level_2/bloc/level_2_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late List<String> lines;
  late List<FeedbackMessage> messages;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
    lines = [];
    messages = [];
    final lineSubscription = deps.dialogue.lineStream.listen(lines.add);
    final messageSubscription = deps.feedback.messageStream.listen(messages.add);
    addTearDown(lineSubscription.cancel);
    addTearDown(messageSubscription.cancel);
  });

  test(
    'level 2 starts with the hero line once per game, other levels say nothing',
    () async {
      final intro = diContainer.get<LevelIntroUseCase>();
      intro(.level1);
      intro(.level2);
      intro(.level2);
      intro(.level3);
      await pumpEventQueue();

      expect(
        lines,
        [HeroReaction.level2Intro.line],
      );
    },
  );

  test(
    'the level 2 bloc plays the intro when it starts but not on retry',
    () async {
      final bloc = Level2Bloc()..add(const Level2Started());
      addTearDown(bloc.close);
      await pumpEventQueue();
      bloc.add(const Level2Retried());
      await pumpEventQueue();

      expect(
        lines,
        [HeroReaction.level2Intro.line],
      );
    },
  );

  test(
    'the first clay pot writes its book record',
    () {
      deps.material.add(.wood);
      deps.fire.load(.fireClayPot);

      diContainer.get<CookOnCampfireUseCase>()(
        .fireClayPot,
        .wood,
        .campfire,
      );

      expect(
        deps.book.book.records,
        [BookRecord.clayPot],
      );
    },
  );

  test(
    'burning cardboard makes the hero react once',
    () async {
      final cook = diContainer.get<CookOnCampfireUseCase>();
      deps.inventory.add(.cookingPot);
      for (var i = 0; i < 2; i++) {
        deps.material
          ..add(.cardboard)
          ..add(.wood);
        deps.material.remove(
          .wood,
          1,
        );
        deps.fire.load(.makeCharcoal);
        cook(
          .makeCharcoal,
          .cardboard,
          .campfire,
        );
      }
      await pumpEventQueue();

      expect(
        lines,
        [HeroReaction.cardboardBurned.line],
      );
    },
  );

  group(
    'eating seeds',
    () {
      test(
        'a seed gives 5 hunger, is gone, and the hero regrets it once',
        () async {
          deps.player.setStats(
            const PlayerStats(
              health: 100,
              hunger: 50,
              thirst: 50,
            ),
          );
          deps.material
            ..add(.seeds)
            ..add(.seeds);
          deps.selection.selectMaterial(.seeds);
          final eat = diContainer.get<EatSeedsUseCase>();

          eat();
          eat();
          await pumpEventQueue();

          expect(
            deps.player.stats.hunger,
            60,
          );
          expect(
            deps.material.count(GameMaterial.seeds),
            0,
          );
          expect(
            deps.selection.selection.material,
            isNull,
          );
          expect(
            messages.first,
            const FeedbackMessage(
              text: 'You ate a seed +5 hunger Nothing will grow from it now',
              mood: .sad,
            ),
          );
          expect(
            lines,
            [HeroReaction.seedsEaten.line],
          );
          expect(
            eat(),
            isFalse,
          );
        },
      );

      test(
        'tapping the hero with seeds selected eats one',
        () async {
          final bloc = HudBloc()..add(const HudStarted());
          addTearDown(bloc.close);
          deps.material.add(.seeds);
          deps.selection.selectMaterial(.seeds);
          await pumpEventQueue();

          bloc.add(const HudCharacterTapped());
          await pumpEventQueue();

          expect(
            deps.material.count(GameMaterial.seeds),
            0,
          );
        },
      );
    },
  );
}
