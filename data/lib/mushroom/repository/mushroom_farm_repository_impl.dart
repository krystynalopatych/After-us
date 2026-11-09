import 'dart:async';

import 'package:domain/mushroom/model/mushroom_farm.dart';
import 'package:domain/mushroom/repository/mushroom_farm_repository.dart';

final class MushroomFarmRepositoryImpl implements MushroomFarmRepository {
  final _farmController = StreamController<MushroomFarm>.broadcast();
  MushroomFarm _farm = const .none();

  @override
  MushroomFarm get farm => _farm;

  @override
  Stream<MushroomFarm> get farmStream => _farmController.stream;

  @override
  void place() => _update(_farm.copyWith(isPlaced: true));

  @override
  void plant() => _update(
    _farm.copyWith(
      isPlanted: true,
      seconds: 0,
    ),
  );

  @override
  void tick() {
    if (_farm.isPlanted && !_farm.isReady) {
      _update(_farm.copyWith(seconds: _farm.seconds + 1));
    }
  }

  @override
  void collect() => _update(_farm.copyWith(seconds: 0));

  @override
  void restore(MushroomFarm farm) => _update(farm);

  @override
  void reset() => _update(const .none());

  void _update(MushroomFarm farm) {
    _farm = farm;
    _farmController.add(farm);
  }
}
