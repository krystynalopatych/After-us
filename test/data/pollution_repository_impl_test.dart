import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:domain/pollution/model/pollution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts clean',
    () {
      final pollution = PollutionRepositoryImpl().pollution;

      expect(
        pollution.airPoints,
        0,
      );
      expect(
        pollution.isWaterPolluted,
        isFalse,
      );
      expect(
        pollution.isSoilPolluted,
        isFalse,
      );
    },
  );

  test(
    'air points add up and never go down',
    () {
      final repository = PollutionRepositoryImpl()
        ..addAirPoints(3)
        ..addAirPoints(2);

      expect(
        repository.pollution.airPoints,
        5,
      );
    },
  );

  test(
    'water and soil stay polluted and keep the other values',
    () {
      final repository = PollutionRepositoryImpl()
        ..addAirPoints(2)
        ..polluteWater();

      expect(
        repository.pollution.isWaterPolluted,
        isTrue,
      );
      expect(
        repository.pollution.isSoilPolluted,
        isFalse,
      );
      expect(
        repository.pollution.airPoints,
        2,
      );

      repository.polluteSoil();

      expect(
        repository.pollution.isWaterPolluted,
        isTrue,
      );
      expect(
        repository.pollution.isSoilPolluted,
        isTrue,
      );
      expect(
        repository.pollution.airPoints,
        2,
      );
    },
  );

  test(
    'emits every change and supports restore and reset',
    () async {
      final repository = PollutionRepositoryImpl();
      final emitted = <Pollution>[];
      final subscription = repository.pollutionStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository
        ..addAirPoints(1)
        ..restore(
          const Pollution(
            airPoints: 6,
            isWaterPolluted: false,
            isSoilPolluted: true,
          ),
        )
        ..reset();
      await pumpEventQueue();

      expect(
        repository.pollution.airPoints,
        0,
      );
      expect(
        repository.pollution.isSoilPolluted,
        isFalse,
      );
      expect(
        emitted.map((pollution) => pollution.airPoints),
        [1, 6, 0],
      );
      expect(
        emitted[1].isSoilPolluted,
        isTrue,
      );
    },
  );
}
