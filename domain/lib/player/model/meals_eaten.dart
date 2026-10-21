import 'package:domain/inventory/model/inventory_item.dart';
import 'package:equatable/equatable.dart';

final class MealsEaten extends Equatable {
  final int day;
  final Map<InventoryItem, int> counts;

  const MealsEaten({
    required this.day,
    required this.counts,
  });

  const MealsEaten.none() : day = 0, counts = const {};

  int countOn(
    int day,
    InventoryItem item,
  ) => day == this.day ? counts[item] ?? 0 : 0;

  MealsEaten copyWith({
    int? day,
    Map<InventoryItem, int>? counts,
  }) => MealsEaten(
    day: day ?? this.day,
    counts: counts ?? this.counts,
  );

  @override
  List<Object?> get props => [day, counts];
}
