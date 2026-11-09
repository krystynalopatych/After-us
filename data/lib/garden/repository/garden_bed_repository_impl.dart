import 'dart:async';

import 'package:domain/garden/model/garden_bed.dart';
import 'package:domain/garden/repository/garden_bed_repository.dart';

final class GardenBedRepositoryImpl implements GardenBedRepository {
  final _bedController = StreamController<GardenBed>.broadcast();
  GardenBed _bed = const .none();

  @override
  GardenBed get bed => _bed;

  @override
  Stream<GardenBed> get bedStream => _bedController.stream;

  @override
  void place() => _update(_bed.copyWith(isPlaced: true));

  @override
  void plant() => _update(_bed.copyWith(seeds: _bed.seeds + 1));

  @override
  void addGreenhouse() => _update(_bed.copyWith(hasGreenhouse: true));

  @override
  void fertilize() => _update(_bed.copyWith(isFertilized: true));

  @override
  void boost(int day) => _update(
    _bed.copyWith(
      seconds: (_bed.seconds + _bed.boostSeconds).clamp(
        0,
        _bed.readySeconds,
      ),
      boostedDay: () => day,
    ),
  );

  @override
  void tick() {
    if (_bed.isPlanted && !_bed.isReady) {
      _update(_bed.copyWith(seconds: _bed.seconds + 1));
    }
  }

  @override
  void harvest() => _update(
    _bed.copyWith(
      seconds: 0,
      isFertilized: false,
    ),
  );

  @override
  void restore(GardenBed bed) => _update(bed);

  @override
  void reset() => _update(const .none());

  void _update(GardenBed bed) {
    _bed = bed;
    _bedController.add(bed);
  }
}
