import 'package:domain/material/model/game_material.dart';

enum CampfireFuel {
  wood(material: .wood),
  plastic(
    material: .plastic,
    isPolluting: true,
  ),
  cloth(
    material: .cloth,
    isPolluting: true,
  ),
  cardboard(
    material: .cardboard,
    isPolluting: true,
  );

  final GameMaterial material;
  final bool isPolluting;

  const CampfireFuel({
    required this.material,
    this.isPolluting = false,
  });

  int get airPoints => isPolluting ? material.airPoints : 0;

  static CampfireFuel? fromMaterial(GameMaterial material) =>
      values.where((fuel) => fuel.material == material).firstOrNull;
}
