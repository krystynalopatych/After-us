import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/note/bloc/note_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'follows the location, opens the note and the hero speaks only after the first reading',
    () async {
      final bloc = NoteBloc()..add(const NoteStarted());
      addTearDown(bloc.close);
      final lines = <String>[];
      final subscription = deps.dialogue.lineStream.listen(lines.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      deps.location.setLocation(.store);
      bloc.add(const NoteTapped());
      await pumpEventQueue();
      expect(
        bloc.state,
        const NoteState(
          location: GameLocation.store,
          isOpen: true,
        ),
      );

      bloc
        ..add(const NoteClosed())
        ..add(const NoteTapped())
        ..add(const NoteClosed());
      await pumpEventQueue();

      expect(
        bloc.state.isOpen,
        isFalse,
      );
      expect(
        lines,
        [HeroReaction.survivorsNote.line],
      );
    },
  );
}
