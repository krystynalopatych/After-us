import 'package:data/construction/repository/construction_repository_impl.dart';
import 'package:domain/construction/model/construction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts with nothing built',
    () {
      expect(
        ConstructionRepositoryImpl().built,
        isEmpty,
      );
    },
  );

  test(
    'build adds a construction once and emits only real changes',
    () async {
      final repository = ConstructionRepositoryImpl();
      final emitted = <Set<Construction>>[];
      final subscription = repository.builtStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository
        ..build(.waterFilter)
        ..build(.waterFilter)
        ..build(.compostPit);
      await pumpEventQueue();

      expect(
        repository.built,
        {Construction.waterFilter, Construction.compostPit},
      );
      expect(
        emitted,
        hasLength(2),
      );
    },
  );

  test(
    'restore replaces the built set and reset clears it',
    () async {
      final repository = ConstructionRepositoryImpl()..build(.rocketStove);

      repository.restore({.waterFilter});
      expect(
        repository.built,
        {Construction.waterFilter},
      );

      repository.reset();
      expect(
        repository.built,
        isEmpty,
      );
    },
  );

  test(
    'does not let callers change the built set',
    () {
      final repository = ConstructionRepositoryImpl()..build(.compostPit);

      expect(
        () => repository.built.clear(),
        throwsUnsupportedError,
      );
    },
  );
}
