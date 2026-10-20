import 'dart:async';

import 'package:domain/station/model/station.dart';
import 'package:domain/station/repository/station_repository.dart';

final class StationRepositoryImpl implements StationRepository {
  final _builtController = StreamController<Set<Station>>.broadcast();
  final _built = <Station>{};

  @override
  Set<Station> get built => Set.unmodifiable(_built);

  @override
  Stream<Set<Station>> get builtStream => _builtController.stream;

  @override
  void build(Station station) {
    if (_built.add(station)) {
      _builtController.add(built);
    }
  }

  @override
  void restore(Set<Station> built) {
    _built
      ..clear()
      ..addAll(built);
    _builtController.add(this.built);
  }

  @override
  void reset() {
    _built.clear();
    _builtController.add(built);
  }
}
