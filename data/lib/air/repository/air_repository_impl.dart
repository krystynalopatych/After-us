import 'dart:async';

import 'package:domain/air/model/air_quality.dart';
import 'package:domain/air/repository/air_repository.dart';

final class AirRepositoryImpl implements AirRepository {
  static const _smokyPoints = 1;
  static const _pollutedPoints = 4;

  final _qualityController = StreamController<AirQuality>.broadcast();
  int _points = 0;

  @override
  int get points => _points;

  @override
  AirQuality get quality => switch (_points) {
    >= _pollutedPoints => .polluted,
    >= _smokyPoints => .smoky,
    _ => .clean,
  };

  @override
  Stream<AirQuality> get qualityStream => _qualityController.stream;

  @override
  void addPoints(int points) {
    _points += points;
    _qualityController.add(quality);
  }

  @override
  void reset() {
    _points = 0;
    _qualityController.add(quality);
  }
}
