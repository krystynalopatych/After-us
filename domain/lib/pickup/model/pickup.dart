import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup_kind.dart';

final class Pickup {
  final int id;
  final GameLocation location;
  final PickupKind kind;
  final double left;
  final double top;

  const Pickup({
    required this.id,
    required this.location,
    required this.kind,
    required this.left,
    required this.top,
  });
}
