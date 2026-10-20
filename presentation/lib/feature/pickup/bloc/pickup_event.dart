part of 'pickup_bloc.dart';

sealed class PickupEvent {
  const PickupEvent();
}

final class PickupStarted extends PickupEvent {
  const PickupStarted();
}

final class PickupTapped extends PickupEvent {
  final Pickup pickup;

  const PickupTapped(this.pickup);
}
