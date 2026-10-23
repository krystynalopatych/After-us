import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/dialogue/bloc/dialogue_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  const readDuration = Duration(milliseconds: 20);

  Future<void> waitRead() => Future<void>.delayed(readDuration * 2);

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  Future<DialogueBloc> startedBloc() async {
    final bloc = DialogueBloc(readDuration: readDuration)..add(const DialogueStarted());
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
}
