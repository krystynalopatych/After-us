import 'package:data/player/repository/player_repository_impl.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts with the initial stats',
    () {
      final stats = PlayerRepositoryImpl().stats;

      expect(
        stats.health,
        100,
      );
      expect(
        stats.hunger,
        80,
      );
      expect(
        stats.thirst,
        80,
      );
      expect(
        stats.healthCeiling,
        100,
      );
    },
  );

  test(
    'setStats replaces the stats and reset brings back the initial ones',
    () async {
      final repository = PlayerRepositoryImpl();
      final emitted = <PlayerStats>[];
      final subscription = repository.statsStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository.setStats(
        const PlayerStats(
          health: 40,
          hunger: 10,
          thirst: 5,
          healthCeiling: 90,
        ),
      );
      await pumpEventQueue();

      expect(
        repository.stats.health,
        40,
      );
      expect(
        repository.stats.healthCeiling,
        90,
      );

      repository.reset();
      await pumpEventQueue();

      expect(
        repository.stats.health,
        100,
      );
      expect(
        repository.stats.thirst,
        80,
      );
      expect(
        emitted.map((stats) => stats.health),
        [40, 100],
      );
    },
  );
}
