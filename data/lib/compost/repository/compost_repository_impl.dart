import 'dart:async';

import 'package:domain/compost/model/compost_pit.dart';
import 'package:domain/compost/repository/compost_repository.dart';

final class CompostRepositoryImpl implements CompostRepository {
  final _pitController = StreamController<CompostPit>.broadcast();
  CompostPit _pit = const .empty();

  @override
  CompostPit get pit => _pit;

  @override
  Stream<CompostPit> get pitStream => _pitController.stream;

  @override
  void addOrganics() {
    if (!_pit.isFull) {
      _update(_pit.copyWith(organics: _pit.organics + 1));
    }
  }

  @override
  void tick() {
    if (_pit.isFull && !_pit.isReady) {
      _update(_pit.copyWith(seconds: _pit.seconds + 1));
    }
  }

  @override
  void empty() => _update(const .empty());

  @override
  void restore(CompostPit pit) => _update(pit);

  @override
  void reset() => _update(const .empty());

  void _update(CompostPit pit) {
    _pit = pit;
    _pitController.add(pit);
  }
}
