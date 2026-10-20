import 'dart:async';

import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';

final class PlayerRepositoryImpl implements PlayerRepository {
  final _statsController = StreamController<PlayerStats>.broadcast();
  PlayerStats _stats = const .initial();

  @override
  PlayerStats get stats => _stats;

  @override
  Stream<PlayerStats> get statsStream => _statsController.stream;

  @override
  void reset() {
    _stats = const .initial();
    _statsController.add(_stats);
  }
}
