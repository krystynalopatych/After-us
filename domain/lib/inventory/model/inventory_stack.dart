import 'package:domain/inventory/model/inventory_item.dart';
import 'package:equatable/equatable.dart';

final class InventoryStack extends Equatable {
  final InventoryItem item;
  final int count;

  const InventoryStack({
    required this.item,
    required this.count,
  });

  InventoryStack copyWith({
    InventoryItem? item,
    int? count,
  }) => InventoryStack(
    item: item ?? this.item,
    count: count ?? this.count,
  );

  @override
  List<Object?> get props => [item, count];
}
