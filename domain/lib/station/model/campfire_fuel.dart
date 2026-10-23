import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/material/model/game_material.dart';

enum CampfireFuel {
  wood(material: .wood),
  plastic(
    material: .plastic,
    isPolluting: true,
    burnReaction: .plasticBurned,
  ),
  cloth(
    material: .cloth,
    isPolluting: true,
    burnReaction: .clothBurned,
  ),
  cardboard(
    material: .cardboard,
    isPolluting: true,
  );

  final GameMaterial material;
  final bool isPolluting;
  final HeroReaction? burnReaction;

  const CampfireFuel({
    required this.material,
    this.isPolluting = false,
    this.burnReaction,
  });

  int get airPoints => isPolluting ? material.airPoints : 0;

  static CampfireFuel? fromMaterial(GameMaterial material) =>
      values.where((fuel) => fuel.material == material).firstOrNull;
}
