part of 'pickup_bloc.dart';

sealed class PickupEvent extends Equatable {
  const PickupEvent();

  @override
  List<Object?> get props => [];
}

final class PickupStarted extends PickupEvent {
  const PickupStarted();
}

final class PickupTapped extends PickupEvent {
  final Pickup pickup;

  const PickupTapped(this.pickup);

  @override
  List<Object?> get props => [pickup];
}

final class PickupKeepTapped extends PickupEvent {
  const PickupKeepTapped();
}

final class PickupThrowTapped extends PickupEvent {
  const PickupThrowTapped();
}

final class PickupThrowTargetTapped extends PickupEvent {
  final GameLocation target;

  const PickupThrowTargetTapped(this.target);

  @override
  List<Object?> get props => [target];
}

final class PickupDismissed extends PickupEvent {
  const PickupDismissed();
}
