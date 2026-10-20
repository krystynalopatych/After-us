import 'dart:async';

import 'package:domain/construction/model/construction.dart';
import 'package:domain/construction/repository/construction_repository.dart';

final class ConstructionRepositoryImpl implements ConstructionRepository {
  final _builtController = StreamController<Set<Construction>>.broadcast();
  final _built = <Construction>{};

  @override
  Set<Construction> get built => Set.unmodifiable(_built);

  @override
  Stream<Set<Construction>> get builtStream => _builtController.stream;

  @override
  void build(Construction construction) {
    if (_built.add(construction)) {
      _builtController.add(built);
    }
  }

  @override
  void restore(Set<Construction> built) {
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
