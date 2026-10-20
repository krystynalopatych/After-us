part of 'hud_bloc.dart';

final class HudState {
  final PlayerStats stats;
  final List<MaterialStock> stocks;
  final List<InventoryStack> inventory;

  const HudState({
    required this.stats,
    required this.stocks,
    required this.inventory,
  });
}
