import 'dart:async';

import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:domain/material/repository/material_repository.dart';

final class MaterialRepositoryImpl implements MaterialRepository {
  final _stocksController = StreamController<List<MaterialStock>>.broadcast();
  final _counts = <GameMaterial, int>{};

  @override
  List<MaterialStock> get stocks => [
    for (final MapEntry(key: material, value: count) in _counts.entries)
      MaterialStock(
        material: material,
        count: count,
      ),
  ];

  @override
  Stream<List<MaterialStock>> get stocksStream => _stocksController.stream;

  @override
  int count(GameMaterial material) => _counts[material] ?? 0;

  @override
  void add(GameMaterial material) {
    _counts.update(
      material,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
    _stocksController.add(stocks);
  }

  @override
  bool remove(
    GameMaterial material,
    int count,
  ) {
    final left = this.count(material) - count;
    if (left < 0) {
      return false;
    }
    if (left == 0) {
      _counts.remove(material);
    } else {
      _counts[material] = left;
    }
    _stocksController.add(stocks);
    return true;
  }

  @override
  void restore(List<MaterialStock> stocks) {
    _counts
      ..clear()
      ..addEntries([
        for (final stock in stocks)
          MapEntry(
            stock.material,
            stock.count,
          ),
      ]);
    _stocksController.add(this.stocks);
  }

  @override
  void reset() {
    _counts.clear();
    _stocksController.add(stocks);
  }
}
