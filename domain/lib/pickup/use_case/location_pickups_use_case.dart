import 'package:async/async.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';

final class LocationPickupsUseCase {
  final LocationRepository _locationRepository;
  final PickupRepository _pickupRepository;

  const LocationPickupsUseCase({
    required this._locationRepository,
    required this._pickupRepository,
  });

  List<Pickup> get pickups => [
    for (final pickup in _pickupRepository.pickups)
      if (pickup.location == _locationRepository.location) pickup,
  ];

  Stream<List<Pickup>> get pickupsStream => StreamGroup.mergeBroadcast<Object>([
    _locationRepository.locationStream,
    _pickupRepository.pickupsStream,
  ]).map((_) => pickups);
}
