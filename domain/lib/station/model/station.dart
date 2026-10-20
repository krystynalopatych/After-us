import 'package:domain/material/model/game_material.dart';

enum Station {
  campfire(cost: {GameMaterial.wood: 1}),
  workbench(cost: {GameMaterial.wood: 1});

  final Map<GameMaterial, int> cost;

  const Station({required this.cost});

  bool isBuiltFrom(GameMaterial material) => cost.containsKey(material);

  bool isAffordableWith(int Function(GameMaterial material) count) => cost.entries.every(
    (entry) => count(entry.key) >= entry.value,
  );
}
