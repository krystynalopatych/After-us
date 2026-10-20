import 'package:domain/pollution/model/air_quality.dart';

final class Pollution {
  static const _smokyAirPoints = 1;
  static const _pollutedAirPoints = 4;

  final int airPoints;
  final bool isWaterPolluted;
  final bool isSoilPolluted;

  const Pollution({
    required this.airPoints,
    required this.isWaterPolluted,
    required this.isSoilPolluted,
  });

  const Pollution.clean() : airPoints = 0, isWaterPolluted = false, isSoilPolluted = false;

  AirQuality get airQuality => switch (airPoints) {
    >= _pollutedAirPoints => .polluted,
    >= _smokyAirPoints => .smoky,
    _ => .clean,
  };
}
