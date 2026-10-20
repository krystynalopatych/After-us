import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:equatable/equatable.dart';

final class Pickup extends Equatable {
  final int id;
  final GameLocation location;
  final PickupKind kind;

  const Pickup({
    required this.id,
    required this.location,
    required this.kind,
  });

  Pickup copyWith({
    int? id,
    GameLocation? location,
    PickupKind? kind,
  }) => Pickup(
    id: id ?? this.id,
    location: location ?? this.location,
    kind: kind ?? this.kind,
  );

  @override
  List<Object?> get props => [id, location, kind];
}
