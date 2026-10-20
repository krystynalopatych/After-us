import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/model/material_stock.dart';

abstract interface class MaterialRepository {
  List<MaterialStock> get stocks;

  Stream<List<MaterialStock>> get stocksStream;

  void add(GameMaterial material);

  void restore(List<MaterialStock> stocks);

  void reset();
}
