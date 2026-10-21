import 'dart:async';

import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';

final class SunSpotRepositoryImpl implements SunSpotRepository {
  final _bottleController = StreamController<SunBottle?>.broadcast();
  SunBottle? _bottle;

  @override
  SunBottle? get bottle => _bottle;

  @override
  Stream<SunBottle?> get bottleStream => _bottleController.stream;

  @override
  void place(SunBottle bottle) => _update(bottle);

  @override
  void tick() {
    if (_bottle case final bottle? when !bottle.isReady) {
      _update(bottle.copyWith(seconds: bottle.seconds + 1));
    }
  }

  @override
  void take() => _update(null);

  @override
  void restore(SunBottle? bottle) => _update(bottle);

  @override
  void reset() => _update(null);

  void _update(SunBottle? bottle) {
    _bottle = bottle;
    _bottleController.add(bottle);
  }
}
