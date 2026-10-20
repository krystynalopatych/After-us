import 'package:domain/pollution/model/air_quality.dart';
import 'package:equatable/equatable.dart';

final class Pollution extends Equatable {
  static const _smokyAirPoints = 1;
  static const _pollutedAirPoints = 4;
  static const _heavyAirPoints = 8;
  static const _lightCeilingDrop = 5;
  static const _mediumCeilingDrop = 10;
  static const _heavyCeilingDrop = 20;

  final int airPoints;
  final bool isWaterPolluted;
  final bool isSoilPolluted;

  const Pollution({
    required this.airPoints,
    required this.isWaterPolluted,
    required this.isSoilPolluted,
  });

  const Pollution.clean() : airPoints = 0, isWaterPolluted = false, isSoilPolluted = false;

  int get dailyHealthCeilingDrop => switch (airPoints) {
    >= _heavyAirPoints => _heavyCeilingDrop,
    >= _pollutedAirPoints => _mediumCeilingDrop,
    >= _smokyAirPoints => _lightCeilingDrop,
    _ => 0,
  };

  AirQuality get airQuality => switch (airPoints) {
    >= _pollutedAirPoints => .polluted,
    >= _smokyAirPoints => .smoky,
    _ => .clean,
  };

  Pollution copyWith({
    int? airPoints,
    bool? isWaterPolluted,
    bool? isSoilPolluted,
  }) => Pollution(
    airPoints: airPoints ?? this.airPoints,
    isWaterPolluted: isWaterPolluted ?? this.isWaterPolluted,
    isSoilPolluted: isSoilPolluted ?? this.isSoilPolluted,
  );

  @override
  List<Object?> get props => [airPoints, isWaterPolluted, isSoilPolluted];
}
