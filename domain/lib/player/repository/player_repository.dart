import 'package:domain/player/model/player_stats.dart';

abstract interface class PlayerRepository {
  PlayerStats get stats;

  Stream<PlayerStats> get statsStream;

  void setStats(PlayerStats stats);

  void reset();
}
