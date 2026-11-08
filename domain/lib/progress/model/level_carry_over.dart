import 'package:domain/construction/model/construction.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/station/model/station.dart';
import 'package:equatable/equatable.dart';

final class LevelCarryOver extends Equatable {
  final List<InventoryStack> inventory;
  final Set<Construction> constructions;
  final Set<Station> stations;

  const LevelCarryOver({
    required this.inventory,
    required this.constructions,
    required this.stations,
  });

  const LevelCarryOver.none() : inventory = const [], constructions = const {}, stations = const {};

  LevelCarryOver copyWith({
    List<InventoryStack>? inventory,
    Set<Construction>? constructions,
    Set<Station>? stations,
  }) => LevelCarryOver(
    inventory: inventory ?? this.inventory,
    constructions: constructions ?? this.constructions,
    stations: stations ?? this.stations,
  );

  @override
  List<Object?> get props => [
    inventory,
    constructions,
    stations,
  ];
}
