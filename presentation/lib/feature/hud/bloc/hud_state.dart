part of 'hud_bloc.dart';

final class HudState {
  final PlayerStats stats;
  final List<MaterialStock> stocks;

  const HudState({
    required this.stats,
    required this.stocks,
  });
}
