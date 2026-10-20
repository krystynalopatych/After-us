part of 'hud_bloc.dart';

final class HudState extends Equatable {
  final PlayerStats stats;
  final List<MaterialStock> stocks;
  final List<InventoryStack> inventory;
  final GameMaterial? selectedMaterial;
  final int? selectedSlot;

  const HudState({
    required this.stats,
    required this.stocks,
    required this.inventory,
    this.selectedMaterial,
    this.selectedSlot,
  });

  HudState copyWith({
    PlayerStats? stats,
    List<MaterialStock>? stocks,
    List<InventoryStack>? inventory,
    GameMaterial? Function()? selectedMaterial,
    int? Function()? selectedSlot,
  }) => HudState(
    stats: stats ?? this.stats,
    stocks: stocks ?? this.stocks,
    inventory: inventory ?? this.inventory,
    selectedMaterial: selectedMaterial != null ? selectedMaterial() : this.selectedMaterial,
    selectedSlot: selectedSlot != null ? selectedSlot() : this.selectedSlot,
  );

  @override
  List<Object?> get props => [stats, stocks, inventory, selectedMaterial, selectedSlot];
}
