import 'package:domain/material/model/game_material.dart';
import 'package:equatable/equatable.dart';

final class Selection extends Equatable {
  final GameMaterial? material;
  final int? slot;

  const Selection({
    this.material,
    this.slot,
  });

  const Selection.none() : material = null, slot = null;

  Selection copyWith({
    GameMaterial? Function()? material,
    int? Function()? slot,
  }) => Selection(
    material: material != null ? material() : this.material,
    slot: slot != null ? slot() : this.slot,
  );

  @override
  List<Object?> get props => [material, slot];
}
