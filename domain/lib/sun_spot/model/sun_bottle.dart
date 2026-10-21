import 'package:domain/inventory/model/inventory_item.dart';
import 'package:equatable/equatable.dart';

final class SunBottle extends Equatable {
  static const readySeconds = 300;

  final InventoryItem item;
  final int seconds;

  const SunBottle({
    required this.item,
    this.seconds = 0,
  });

  bool get isReady => seconds >= readySeconds;

  double get progress => seconds / readySeconds;

  InventoryItem get result => item == .sodisStrainedWater ? .sodisCleanWater : item;

  SunBottle copyWith({
    InventoryItem? item,
    int? seconds,
  }) => SunBottle(
    item: item ?? this.item,
    seconds: seconds ?? this.seconds,
  );

  @override
  List<Object?> get props => [item, seconds];
}
