import 'package:data/material/repository/material_repository_impl.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/model/material_stock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'counts materials in the order they were first found',
    () {
      final repository = MaterialRepositoryImpl()
        ..add(.wood)
        ..add(.plastic)
        ..add(.wood);

      expect(
        repository.stocks.map((stock) => stock.material),
        [GameMaterial.wood, GameMaterial.plastic],
      );
      expect(
        repository.stocks.map((stock) => stock.count),
        [2, 1],
      );
    },
  );

  test(
    'count returns zero for a material that was never found',
    () {
      final repository = MaterialRepositoryImpl()..add(.wood);

      expect(
        repository.count(.wood),
        1,
      );
      expect(
        repository.count(.metal),
        0,
      );
    },
  );

  test(
    'remove takes the amount only when there is enough',
    () {
      final repository = MaterialRepositoryImpl()
        ..add(.sand)
        ..add(.sand)
        ..add(.sand);

      expect(
        repository.remove(
          .sand,
          4,
        ),
        isFalse,
      );
      expect(
        repository.count(.sand),
        3,
      );
      expect(
        repository.remove(
          .sand,
          2,
        ),
        isTrue,
      );
      expect(
        repository.count(.sand),
        1,
      );
      expect(
        repository.remove(
          .sand,
          1,
        ),
        isTrue,
      );
      expect(
        repository.stocks,
        isEmpty,
      );
    },
  );

  test(
    'restore replaces the counts and reset clears them',
    () async {
      final repository = MaterialRepositoryImpl()..add(.metal);
      final emitted = <List<MaterialStock>>[];
      final subscription = repository.stocksStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository.restore(const [
        MaterialStock(
          material: .sand,
          count: 2,
        ),
        MaterialStock(
          material: .cloth,
          count: 1,
        ),
      ]);
      await pumpEventQueue();

      expect(
        repository.stocks.map((stock) => stock.material),
        [GameMaterial.sand, GameMaterial.cloth],
      );
      expect(
        repository.stocks.first.count,
        2,
      );

      repository.reset();
      await pumpEventQueue();

      expect(
        repository.stocks,
        isEmpty,
      );
      expect(
        emitted.map((stocks) => stocks.length),
        [2, 0],
      );
    },
  );
}
