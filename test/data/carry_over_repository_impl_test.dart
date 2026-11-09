import 'package:data/progress/repository/carry_over_repository_impl.dart';
import 'package:domain/inventory/model/inventory_stack.dart';
import 'package:domain/progress/model/level_carry_over.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const carryOver = LevelCarryOver(
    inventory: [
      InventoryStack(
        item: .berries,
        count: 2,
      ),
    ],
    constructions: {.waterFilter},
    stations: {.workbench},
  );

  test(
    'a level without a kept carry-over starts with nothing',
    () {
      expect(
        CarryOverRepositoryImpl().carryOver(.level2),
        const LevelCarryOver.none(),
      );
    },
  );

  test(
    'keeps the carry-over for its level only',
    () {
      final repository = CarryOverRepositoryImpl()
        ..keep(
          .level2,
          carryOver,
        );

      expect(
        repository.carryOver(.level2),
        carryOver,
      );
      expect(
        repository.carryOver(.level3),
        const LevelCarryOver.none(),
      );
    },
  );

  test(
    'a newer carry-over replaces the old one',
    () {
      final repository = CarryOverRepositoryImpl()
        ..keep(
          .level2,
          carryOver,
        )
        ..keep(
          .level2,
          const LevelCarryOver.none(),
        );

      expect(
        repository.carryOver(.level2),
        const LevelCarryOver.none(),
      );
    },
  );

  test(
    'reset forgets every carry-over',
    () {
      final repository = CarryOverRepositoryImpl()
        ..keep(
          .level2,
          carryOver,
        )
        ..reset();

      expect(
        repository.carryOver(.level2),
        const LevelCarryOver.none(),
      );
    },
  );
}
