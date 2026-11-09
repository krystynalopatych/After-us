import 'package:domain/day/model/game_day.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:equatable/equatable.dart';

final class InventoryStack extends Equatable {
  static const spoilAge = GameDay.secondsPerDay;

  final InventoryItem item;
  final int count;
  final int age;

  const InventoryStack({
    required this.item,
    required this.count,
    this.age = 0,
  });

  bool get isSpoiled => age >= spoilAge;

  bool canTake(
    InventoryItem item,
    int age,
  ) => this.item == item && isSpoiled == (age >= spoilAge);

  InventoryStack merged(int age) => copyWith(
    count: count + 1,
    age: this.age > age ? this.age : age,
  );

  InventoryStack copyWith({
    InventoryItem? item,
    int? count,
    int? age,
  }) => InventoryStack(
    item: item ?? this.item,
    count: count ?? this.count,
    age: age ?? this.age,
  );

  @override
  List<Object?> get props => [item, count, age];
}
