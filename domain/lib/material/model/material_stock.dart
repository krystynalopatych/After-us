import 'package:domain/material/model/game_material.dart';
import 'package:equatable/equatable.dart';

final class MaterialStock extends Equatable {
  final GameMaterial material;
  final int count;

  const MaterialStock({
    required this.material,
    required this.count,
  });

  MaterialStock copyWith({
    GameMaterial? material,
    int? count,
  }) => MaterialStock(
    material: material ?? this.material,
    count: count ?? this.count,
  );

  @override
  List<Object?> get props => [material, count];
}
