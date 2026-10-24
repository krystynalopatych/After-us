import 'package:domain/day/model/game_day.dart';
import 'package:domain/sound/model/game_sound.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/dialogue/bloc/dialogue_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  const readDuration = Duration(milliseconds: 20);
  const wakeDuration = Duration(milliseconds: 20);

  Future<void> waitRead() => Future<void>.delayed(readDuration * 2);

  Future<void> waitWake() => Future<void>.delayed(wakeDuration * 2);

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  Future<DialogueBloc> startedBloc() async {
    final bloc = DialogueBloc(
      readDuration: readDuration,
      wakeDuration: wakeDuration,
    )..add(const DialogueStarted());
    addTearDown(bloc.close);
    await pumpEventQueue();
    return bloc;
  }

  test(
    'shows a line and keeps it while it is being typed',
    () async {
      final bloc = await startedBloc();

      deps.dialogue.say('A clear bottle...');
      await pumpEventQueue();
      await waitRead();

      expect(
        bloc.state.line,
        'A clear bottle...',
      );
    },
  );

  test(
    'hides the line after the read time once it is typed',
    () async {
      final bloc = await startedBloc();

      deps.dialogue.say('A clear bottle...');
      await pumpEventQueue();
      bloc.add(const DialogueLineTyped());
      await pumpEventQueue();
      await waitRead();

      expect(
        bloc.state.line,
        isNull,
      );
    },
  );

  test(
    'queues lines and shows them one after another',
    () async {
      final bloc = await startedBloc();

      deps.dialogue
        ..say('first')
        ..say('second');
      await pumpEventQueue();

      expect(
        bloc.state.line,
        'first',
      );
      expect(
        bloc.state.queue,
        ['second'],
      );

      bloc.add(const DialogueLineTyped());
      await pumpEventQueue();
      await waitRead();

      expect(
        bloc.state.line,
        'second',
      );
      expect(
        bloc.state.queue,
        isEmpty,
      );
    },
  );

  test(
    'the hero voice plays while a line is typed and stops when it is typed',
    () async {
      final bloc = await startedBloc();

      deps.dialogue.say('A clear bottle...');
      await pumpEventQueue();
      expect(
        deps.sound.looping,
        {GameSound.speak},
      );

      bloc.add(const DialogueLineTyped());
      await pumpEventQueue();
      expect(
        deps.sound.looping,
        isEmpty,
      );
    },
  );

  test(
    'the hero voice starts again for the next queued line',
    () async {
      final bloc = await startedBloc();

      deps.dialogue
        ..say('first')
        ..say('second');
      await pumpEventQueue();
      bloc.add(const DialogueLineTyped());
      await pumpEventQueue();
      await waitRead();

      expect(
        bloc.state.line,
        'second',
      );
      expect(
        deps.sound.looping,
        {GameSound.speak},
      );
    },
  );

  test(
    'the hero voice stops when the dialogue closes',
    () async {
      final bloc = DialogueBloc(readDuration: readDuration)..add(const DialogueStarted());
      await pumpEventQueue();

      deps.dialogue.say('A clear bottle...');
      await pumpEventQueue();
      await bloc.close();

      expect(
        deps.sound.looping,
        isEmpty,
      );
    },
  );

  void startNight() => deps.day.setDay(
    const GameDay(
      number: 2,
      seconds: 0,
      nightSeconds: GameDay.nightLength,
    ),
  );

  void endNight() => deps.day.setDay(
    const GameDay(
      number: 2,
      seconds: 0,
    ),
  );

  test(
    'lines said at night wait until the hero wakes up in the morning',
    () async {
      final bloc = await startedBloc();

      startNight();
      deps.dialogue.say('The air is dirty...');
      await pumpEventQueue();
      expect(
        bloc.state.line,
        isNull,
      );
      expect(
        bloc.state.queue,
        ['The air is dirty...'],
      );
      expect(
        deps.sound.looping,
        isEmpty,
      );

      endNight();
      await pumpEventQueue();
      expect(
        bloc.state.line,
        isNull,
      );

      await waitWake();
      expect(
        bloc.state.line,
        'The air is dirty...',
      );
      expect(
        bloc.state.queue,
        isEmpty,
      );
      expect(
        deps.sound.looping,
        {GameSound.speak},
      );
    },
  );

  test(
    'a queued line does not start while it is night',
    () async {
      final bloc = await startedBloc();

      deps.dialogue
        ..say('first')
        ..say('second');
      await pumpEventQueue();
      startNight();
      await pumpEventQueue();
      bloc.add(const DialogueLineTyped());
      await pumpEventQueue();
      await waitRead();

      expect(
        bloc.state.line,
        isNull,
      );
      expect(
        bloc.state.queue,
        ['second'],
      );

      endNight();
      await pumpEventQueue();
      await waitWake();
      expect(
        bloc.state.line,
        'second',
      );
    },
  );

  test(
    'a bloc started at night waits for the morning',
    () async {
      startNight();
      final bloc = await startedBloc();

      deps.dialogue.say('Good morning...');
      await pumpEventQueue();
      expect(
        bloc.state.isAwake,
        isFalse,
      );
      expect(
        bloc.state.line,
        isNull,
      );

      endNight();
      await pumpEventQueue();
      await waitWake();
      expect(
        bloc.state.line,
        'Good morning...',
      );
    },
  );
}
