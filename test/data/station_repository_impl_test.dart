import 'package:data/station/repository/station_repository_impl.dart';
import 'package:domain/station/model/station.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts with no stations',
    () {
      expect(
        StationRepositoryImpl().built,
        isEmpty,
      );
    },
  );

  test(
    'build adds a station once and emits only real changes',
    () async {
      final repository = StationRepositoryImpl();
      final emitted = <Set<Station>>[];
      final subscription = repository.builtStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository
        ..build(.campfire)
        ..build(.campfire)
        ..build(.workbench);
      await pumpEventQueue();

      expect(
        repository.built,
        {Station.campfire, Station.workbench},
      );
      expect(
        emitted,
        hasLength(2),
      );
    },
  );

  test(
    'restore replaces the stations and reset clears them',
    () {
      final repository = StationRepositoryImpl()..build(.campfire);

      repository.restore({.workbench});
      expect(
        repository.built,
        {Station.workbench},
      );

      repository.reset();
      expect(
        repository.built,
        isEmpty,
      );
    },
  );

  test(
    'does not let callers change the stations',
    () {
      final repository = StationRepositoryImpl()..build(.workbench);

      expect(
        () => repository.built.clear(),
        throwsUnsupportedError,
      );
    },
  );
}
