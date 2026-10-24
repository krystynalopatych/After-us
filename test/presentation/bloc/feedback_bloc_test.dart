import 'package:domain/character/model/character_mood.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/sound/model/game_sound.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/feedback/bloc/feedback_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  const displayDuration = Duration(milliseconds: 20);
  const burned = FeedbackMessage(
    text: 'You burned plastic. Air quality -3.',
    heroLine: 'Cough... Next time I should think harder.',
    mood: .sad,
  );
  const built = FeedbackMessage(
    text: 'You built a rocket stove.',
    mood: .happy,
  );

  Future<void> waitDisplay() => Future<void>.delayed(displayDuration * 2);

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'shows a message and sets the hero mood',
    () async {
      final bloc = FeedbackBloc(displayDuration: displayDuration)..add(const FeedbackStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      deps.feedback.show(burned);
      await pumpEventQueue();

      expect(
        bloc.state.message,
        burned,
      );
      expect(
        deps.character.mood,
        CharacterMood.sad,
      );
    },
  );

  test(
    'hides the message after the display time and resets the mood',
    () async {
      final bloc = FeedbackBloc(displayDuration: displayDuration)..add(const FeedbackStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      deps.feedback.show(burned);
      await pumpEventQueue();
      await waitDisplay();

      expect(
        bloc.state.message,
        isNull,
      );
      expect(
        deps.character.mood,
        CharacterMood.normal,
      );
    },
  );

  test(
    'queues messages and shows them one after another',
    () async {
      final bloc = FeedbackBloc(displayDuration: displayDuration)..add(const FeedbackStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      deps.feedback
        ..show(burned)
        ..show(built);
      await pumpEventQueue();

      expect(
        bloc.state.message,
        burned,
      );
      expect(
        bloc.state.queue,
        [built],
      );

      await Future<void>.delayed(displayDuration * 1.5);

      expect(
        bloc.state.message,
        built,
      );
      expect(
        bloc.state.queue,
        isEmpty,
      );
      expect(
        deps.character.mood,
        CharacterMood.happy,
      );

      await waitDisplay();

      expect(
        bloc.state.message,
        isNull,
      );
    },
  );

  test(
    'plays the message sound when a sad message is shown',
    () async {
      final bloc = FeedbackBloc(displayDuration: displayDuration)..add(const FeedbackStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      deps.feedback.show(built);
      await pumpEventQueue();
      expect(
        deps.sound.played,
        isEmpty,
      );

      deps.feedback.show(burned);
      await pumpEventQueue();
      expect(
        deps.sound.played,
        isEmpty,
      );

      await waitDisplay();
      expect(
        deps.sound.played,
        [GameSound.message],
      );
    },
  );
}
