import 'dart:async';

import 'package:domain/material/model/game_material.dart';
import 'package:domain/selection/model/selection.dart';
import 'package:domain/selection/repository/selection_repository.dart';

final class SelectionRepositoryImpl implements SelectionRepository {
  final _selectionController = StreamController<Selection>.broadcast();
  Selection _selection = const .none();

  @override
  Selection get selection => _selection;

  @override
  Stream<Selection> get selectionStream => _selectionController.stream;

  @override
  void selectMaterial(GameMaterial? material) => _update(Selection(material: material));

  @override
  void selectSlot(int? slot) => _update(Selection(slot: slot));

  @override
  void reset() => _update(const .none());

  void _update(Selection selection) {
    _selection = selection;
    _selectionController.add(selection);
  }
}
