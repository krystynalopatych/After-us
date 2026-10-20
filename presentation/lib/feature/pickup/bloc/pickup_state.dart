part of 'pickup_bloc.dart';

enum PickupStep {
  choice,
  throwTarget,
  inventoryFull,
}

final class PickupState {
  final List<Pickup> pickups;
  final Pickup? found;
  final PickupStep step;

  const PickupState({
    this.pickups = const [],
    this.found,
    this.step = .choice,
  });
}
