import 'package:data/save/repository/save_repository_impl.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  GameSave save(
    GameLevel level,
    int minute,
  ) => GameSave(
    level: level,
    location: .house,
    savedAt: DateTime(
      2026,
      10,
      20,
      12,
      minute,
    ),
    day: const .first(),
    stats: const .initial(),
    materials: const [],
    inventory: const [],
    pickups: const [],
    pollution: const .clean(),
    constructions: const {},
    stations: const {},
  );

  test(
    'keeps saves in the order they were made',
    () {
      final first = save(
        .level1,
        1,
      );
      final second = save(
        .level2,
        2,
      );
      final repository = SaveRepositoryImpl()
        ..addSave(first)
        ..addSave(second);

      expect(
        repository.saves,
        [first, second],
      );
    },
  );

  test(
    'does not let callers change the saves list',
    () {
      final repository = SaveRepositoryImpl()
        ..addSave(
          save(
            .level1,
            1,
          ),
        );

      expect(
        () => repository.saves.clear(),
        throwsUnsupportedError,
      );
    },
  );

  test(
    'hands out a loaded save only once',
    () {
      final loaded = save(
        .level1,
        3,
      );
      final repository = SaveRepositoryImpl();

      expect(
        repository.takeLoadedSave(),
        isNull,
      );

      repository.load(loaded);

      expect(
        repository.takeLoadedSave(),
        same(loaded),
      );
      expect(
        repository.takeLoadedSave(),
        isNull,
      );
    },
  );
}
