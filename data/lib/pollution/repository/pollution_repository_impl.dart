import 'dart:async';

import 'package:domain/pollution/model/pollution.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';

final class PollutionRepositoryImpl implements PollutionRepository {
  final _pollutionController = StreamController<Pollution>.broadcast();
  Pollution _pollution = const .clean();

  @override
  Pollution get pollution => _pollution;

  @override
  Stream<Pollution> get pollutionStream => _pollutionController.stream;

  @override
  void addAirPoints(int points) => _update(
    Pollution(
      airPoints: _pollution.airPoints + points,
      isWaterPolluted: _pollution.isWaterPolluted,
      isSoilPolluted: _pollution.isSoilPolluted,
    ),
  );

  @override
  void polluteWater() => _update(
    Pollution(
      airPoints: _pollution.airPoints,
      isWaterPolluted: true,
      isSoilPolluted: _pollution.isSoilPolluted,
    ),
  );

  @override
  void polluteSoil() => _update(
    Pollution(
      airPoints: _pollution.airPoints,
      isWaterPolluted: _pollution.isWaterPolluted,
      isSoilPolluted: true,
    ),
  );

  @override
  void restore(Pollution pollution) => _update(pollution);

  @override
  void reset() => _update(const .clean());

  void _update(Pollution pollution) {
    _pollution = pollution;
    _pollutionController.add(pollution);
  }
}
