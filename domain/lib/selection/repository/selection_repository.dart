import 'package:domain/material/model/game_material.dart';
import 'package:domain/selection/model/selection.dart';

abstract interface class SelectionRepository {
  Selection get selection;

  Stream<Selection> get selectionStream;

  void selectMaterial(GameMaterial? material);

  void selectSlot(int? slot);

  void reset();
}
