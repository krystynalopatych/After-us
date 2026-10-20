import 'package:domain/material/model/game_material.dart';

final class MaterialStock {
  final GameMaterial material;
  final int count;

  const MaterialStock({
    required this.material,
    required this.count,
  });
}
