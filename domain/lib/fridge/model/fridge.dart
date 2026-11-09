import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:equatable/equatable.dart';

final class Fridge extends Equatable {
  static const slotCount = 4;
  static const stackSize = 5;

  final List<InventoryStack?> slots;
  final int? wateredDay;

  const Fridge({
    required this.slots,
    this.wateredDay,
  });

  const Fridge.empty() : slots = const [null, null, null, null], wateredDay = null;

  bool isCoolingOn(int day) => wateredDay == day;

  bool canPut(
    int slot,
    InventoryItem item, {
    int age = 0,
  }) => switch (slots.elementAtOrNull(slot)) {
    null => slot >= 0 && slot < slotCount,
    final stack =>
      stack.canTake(
            item,
            age,
          ) &&
          stack.count < stackSize,
  };

  Fridge copyWith({
    List<InventoryStack?>? slots,
    int? Function()? wateredDay,
  }) => Fridge(
    slots: slots ?? this.slots,
    wateredDay: wateredDay != null ? wateredDay() : this.wateredDay,
  );

  @override
  List<Object?> get props => [
    slots,
    wateredDay,
  ];
}
