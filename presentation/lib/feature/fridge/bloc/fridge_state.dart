part of 'fridge_bloc.dart';

final class FridgeState extends Equatable {
  final List<InventoryStack?> slots;
  final bool isCooling;

  const FridgeState({
    this.slots = const [null, null, null, null],
    this.isCooling = false,
  });

  FridgeState copyWith({
    List<InventoryStack?>? slots,
    bool? isCooling,
  }) => FridgeState(
    slots: slots ?? this.slots,
    isCooling: isCooling ?? this.isCooling,
  );

  @override
  List<Object?> get props => [slots, isCooling];
}
