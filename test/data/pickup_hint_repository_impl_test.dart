import 'package:data/pickup/repository/pickup_hint_repository_impl.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'hear returns true only the first time a kind is heard',
    () {
      final repository = PickupHintRepositoryImpl();

      expect(
        repository.hear(.cloth),
        isTrue,
      );
      expect(
        repository.hear(.cloth),
        isFalse,
      );
      expect(
        repository.heard,
        {PickupKind.cloth},
      );
    },
  );

  test(
    'reset forgets every heard kind',
    () {
      final repository = PickupHintRepositoryImpl()
        ..hear(.wood)
        ..hear(.metal)
        ..reset();

      expect(
        repository.heard,
        isEmpty,
      );
      expect(
        repository.hear(.wood),
        isTrue,
      );
    },
  );
}
