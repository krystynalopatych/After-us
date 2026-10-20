import 'package:domain/location/model/game_location.dart';
import 'package:domain/progress/model/game_level.dart';

final class GameSave {
  final GameLevel level;
  final GameLocation location;
  final DateTime savedAt;

  const GameSave({
    required this.level,
    required this.location,
    required this.savedAt,
  });
}
