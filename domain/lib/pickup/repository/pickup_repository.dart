import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/progress/model/game_level.dart';

abstract interface class PickupRepository {
  List<Pickup> get pickups;

  Stream<List<Pickup>> get pickupsStream;

  void startLevel(GameLevel level);

  void collect(Pickup pickup);
}
