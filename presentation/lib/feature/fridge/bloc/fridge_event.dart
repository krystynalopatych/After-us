part of 'fridge_bloc.dart';

sealed class FridgeEvent extends Equatable {
  const FridgeEvent();

  @override
  List<Object?> get props => [];
}

final class FridgeStarted extends FridgeEvent {
  const FridgeStarted();
}

final class FridgeSlotTapped extends FridgeEvent {
  final int index;

  const FridgeSlotTapped(this.index);

  @override
  List<Object?> get props => [index];
}
