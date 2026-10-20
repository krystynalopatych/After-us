import 'dart:math';

import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/player/repository/player_repository.dart';

final class TravelUseCase {
  static const _farTripThirst = 10.0;

  final LocationRepository _locationRepository;
  final PlayerRepository _playerRepository;

  const TravelUseCase({
    required this._locationRepository,
    required this._playerRepository,
  });

  void call(GameLocation destination) {
    final from = _locationRepository.location;
    if (from != destination && (from.isFar || destination.isFar)) {
      final stats = _playerRepository.stats;
      _playerRepository.setStats(
        stats.copyWith(
          thirst: max(
            0.0,
            stats.thirst - _farTripThirst,
          ),
        ),
      );
    }
    _locationRepository.setLocation(destination);
  }
}
