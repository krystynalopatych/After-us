import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';

final class ThrowPickupUseCase {
  final PickupRepository _pickupRepository;
  final PollutionRepository _pollutionRepository;

  const ThrowPickupUseCase({
    required this._pickupRepository,
    required this._pollutionRepository,
  });

  void call(
    Pickup pickup,
    GameLocation target,
  ) {
    if (pickup.kind.material case final material?) {
      switch (target) {
        case .lake when material.pollutesWater:
          _pollutionRepository.polluteWater();
        case .forest when material.pollutesSoil:
          _pollutionRepository.polluteSoil();
        case .lake || .forest:
          break;
        case .dump || .house || .store || .garage:
          _pollutionRepository.addAirPoints(material.airPoints);
      }
    }
    _pickupRepository.collect(pickup);
  }
}
