part of 'hud_bloc.dart';

final class HudState {
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
}
