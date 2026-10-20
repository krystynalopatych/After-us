import 'package:domain/character/model/character_mood.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';
import 'package:presentation/feature/character/bloc/character_bloc.dart';
import 'package:presentation/feature/goal/bloc/goal_bloc.dart';
import 'package:presentation/feature/load_game/bloc/load_game_bloc.dart';
import 'package:presentation/feature/sky/bloc/sky_bloc.dart';
import 'package:presentation/feature/start/bloc/start_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'AppBloc starts with an empty state',
    () async {
      final bloc = AppBloc();
      addTearDown(bloc.close);

      expect(
        bloc.state,
        isA<AppState>(),
      );
    },
  );

  group(
    'CharacterBloc',
    () {
      test(
        'starts with the stored mood and follows its changes',
        () async {
          deps.character.setMood(.sad);
          final bloc = CharacterBloc()..add(const CharacterStarted());
          addTearDown(bloc.close);

          expect(
            bloc.state,
            CharacterState.sad,
          );
          await pumpEventQueue();

          deps.character.setMood(.happy);
          await pumpEventQueue();

          expect(
            bloc.state,
            CharacterState.happy,
          );
        },
      );
    },
  );

  group(
    'StartBloc',
    () {
      test(
        'start sets the hero back to normal and shows the main menu',
        () async {
          deps.character.setMood(.sad);
          final bloc = StartBloc()..add(const StartStarted());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expect(
            deps.character.mood,
            CharacterMood.normal,
          );
          expect(
            bloc.state.isLevelSelection,
            isFalse,
          );
          expect(
            bloc.state.unlockedLevel,
            GameLevel.level1,
          );
        },
      );

      test(
        'new game resets progress and opens level selection, back closes it',
        () async {
          deps.progress.completeLevel(.level1);
          final bloc = StartBloc();
          addTearDown(bloc.close);

          bloc.add(const StartNewGameTapped());
          await pumpEventQueue();

          expect(
            bloc.state.isLevelSelection,
            isTrue,
          );
          expect(
            bloc.state.unlockedLevel,
            GameLevel.level1,
          );
          expect(
            deps.progress.unlockedLevel,
            GameLevel.level1,
          );

          bloc.add(const StartBackTapped());
          await pumpEventQueue();

          expect(
            bloc.state.isLevelSelection,
            isFalse,
          );
        },
      );

      test(
        'exit asks the app to close',
        () async {
          final bloc = StartBloc()..add(const StartExitTapped());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expect(
            deps.app.exitCount,
            1,
          );
        },
      );
    },
  );

  group(
    'LoadGameBloc',
    () {
      GameSave save(GameLevel level) => GameSave(
        level: level,
        location: .lake,
        savedAt: DateTime(
          2026,
          10,
          20,
        ),
        day: const .first(),
        stats: const .initial(),
        materials: const [],
        inventory: const [],
        pickups: const [],
        pollution: const .clean(),
        constructions: const {},
      );

      test(
        'lists the saves when started',
        () async {
          final first = save(.level1);
          final second = save(.level2);
          deps.save
            ..addSave(first)
            ..addSave(second);
          final bloc = LoadGameBloc()..add(const LoadGameStarted());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expect(
            bloc.state.saves,
            [first, second],
          );
        },
      );

      test(
        'tapping a save marks it as the one to load',
        () async {
          final chosen = save(.level2);
          final bloc = LoadGameBloc()..add(LoadGameSaveTapped(chosen));
          addTearDown(bloc.close);
          await pumpEventQueue();

          expect(
            deps.save.takeLoadedSave(),
            same(chosen),
          );
        },
      );
    },
  );

  test(
    'SkyBloc maps air quality to the sky state',
    () async {
      final bloc = SkyBloc()..add(const SkyStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state,
        SkyState.clear,
      );

      deps.pollution.addAirPoints(1);
      await pumpEventQueue();
      expect(
        bloc.state,
        SkyState.smoky,
      );

      deps.pollution.addAirPoints(3);
      await pumpEventQueue();
      expect(
        bloc.state,
        SkyState.polluted,
      );

      deps.pollution.reset();
      await pumpEventQueue();
      expect(
        bloc.state,
        SkyState.clear,
      );
    },
  );

  test(
    'GoalBloc starts with the built constructions and follows new ones',
    () async {
      deps.construction.build(.compostPit);
      final bloc = GoalBloc()..add(const GoalStarted());
      addTearDown(bloc.close);

      expect(
        bloc.state.built,
        {Construction.compostPit},
      );
      await pumpEventQueue();

      deps.construction.build(.waterFilter);
      await pumpEventQueue();

      expect(
        bloc.state.built,
        {Construction.compostPit, Construction.waterFilter},
      );
    },
  );
}
