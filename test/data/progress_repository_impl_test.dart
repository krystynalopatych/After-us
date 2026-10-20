import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'only level 1 is unlocked at first',
    () {
      expect(
        ProgressRepositoryImpl().unlockedLevel,
        GameLevel.level1,
      );
    },
  );

  test(
    'completing a level unlocks the next one',
    () {
      final repository = ProgressRepositoryImpl()..completeLevel(.level1);
      expect(
        repository.unlockedLevel,
        GameLevel.level2,
      );

      repository.completeLevel(.level2);
      expect(
        repository.unlockedLevel,
        GameLevel.level3,
      );
    },
  );

  test(
    'completing the last level or an older level changes nothing',
    () {
      final repository = ProgressRepositoryImpl()
        ..completeLevel(.level1)
        ..completeLevel(.level2)
        ..completeLevel(.level3);
      expect(
        repository.unlockedLevel,
        GameLevel.level3,
      );

      repository.completeLevel(.level1);
      expect(
        repository.unlockedLevel,
        GameLevel.level3,
      );
    },
  );

  test(
    'reset locks everything except level 1',
    () {
      final repository = ProgressRepositoryImpl()
        ..completeLevel(.level1)
        ..reset();

      expect(
        repository.unlockedLevel,
        GameLevel.level1,
      );
    },
  );
}
