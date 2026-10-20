import 'dart:async';

import 'package:domain/location/model/game_location.dart';
import 'package:domain/location/repository/location_repository.dart';

final class LocationRepositoryImpl implements LocationRepository {
  final _locationController = StreamController<GameLocation>.broadcast();
  GameLocation _location = .house;

  @override
  GameLocation get location => _location;

  @override
  Stream<GameLocation> get locationStream => _locationController.stream;

  @override
  void setLocation(GameLocation location) {
    _location = location;
    _locationController.add(location);
  }
}
