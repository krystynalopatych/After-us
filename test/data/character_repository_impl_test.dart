import 'package:data/character/repository/character_repository_impl.dart';
import 'package:domain/character/model/character_mood.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts normal and emits every new mood',
    () async {
      final repository = CharacterRepositoryImpl();
      final moods = <CharacterMood>[];
      final subscription = repository.moodStream.listen(moods.add);
      addTearDown(subscription.cancel);

      expect(
        repository.mood,
        CharacterMood.normal,
      );

      repository
        ..setMood(.happy)
        ..setMood(.sad);
      await pumpEventQueue();

      expect(
        repository.mood,
        CharacterMood.sad,
      );
      expect(
        moods,
        [CharacterMood.happy, CharacterMood.sad],
      );
    },
  );
}
