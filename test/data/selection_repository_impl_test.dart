import 'package:data/selection/repository/selection_repository_impl.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/selection/model/selection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'starts with nothing selected',
    () {
      expect(
        SelectionRepositoryImpl().selection,
        const Selection.none(),
      );
    },
  );

  test(
    'selecting a material clears the slot and selecting a slot clears the material',
    () async {
      final repository = SelectionRepositoryImpl();
      final emitted = <Selection>[];
      final subscription = repository.selectionStream.listen(emitted.add);
      addTearDown(subscription.cancel);

      repository.selectSlot(3);
      repository.selectMaterial(.wood);
      expect(
        repository.selection,
        const Selection(material: GameMaterial.wood),
      );

      repository.selectSlot(1);
      expect(
        repository.selection,
        const Selection(slot: 1),
      );
      await pumpEventQueue();

      expect(
        emitted,
        hasLength(3),
      );
    },
  );

  test(
    'reset clears the selection',
    () {
      final repository = SelectionRepositoryImpl()..selectMaterial(.metal);

      repository.reset();

      expect(
        repository.selection,
        const Selection.none(),
      );
    },
  );
}
