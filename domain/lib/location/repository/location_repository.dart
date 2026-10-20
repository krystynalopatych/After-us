import 'package:domain/location/model/game_location.dart';

abstract interface class LocationRepository {
  GameLocation get location;

  Stream<GameLocation> get locationStream;

  void setLocation(GameLocation location);
}
