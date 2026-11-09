import 'package:domain/day/model/game_day.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:equatable/equatable.dart';

final class Fridge extends Equatable {
  static const slotCount = 4;
  static const stackSize = 5;
  static const _dayHours = 14;
  static const _graceHours = 2;
  static const morningGraceSeconds = GameDay.secondsPerDay * _graceHours ~/ _dayHours;

  final List<InventoryStack?> slots;
  final int? wateredDay;

  const Fridge({
    required this.slots,
    this.wateredDay,
  });

  const Fridge.empty() : slots = const [null, null, null, null], wateredDay = null;

  bool isWateredOn(int day) => wateredDay == day;

  bool isCoolingOn(GameDay day) =>
      isWateredOn(day.number) || (wateredDay == day.number - 1 && day.seconds < morningGraceSeconds);

  bool get hasFood => slots.nonNulls.isNotEmpty;

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
