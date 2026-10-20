part of 'pickup_bloc.dart';

enum PickupStep {
  choice,
  throwTarget,
  inventoryFull,
}

final class PickupState extends Equatable {
  final List<Pickup> pickups;
  final Pickup? found;
  final PickupStep step;

  const PickupState({
    this.pickups = const [],
    this.found,
    this.step = .choice,
  });

  PickupState copyWith({
    List<Pickup>? pickups,
    Pickup? Function()? found,
    PickupStep? step,
  }) => PickupState(
    pickups: pickups ?? this.pickups,
    found: found != null ? found() : this.found,
    step: step ?? this.step,
  );

  @override
  List<Object?> get props => [pickups, found, step];
}
