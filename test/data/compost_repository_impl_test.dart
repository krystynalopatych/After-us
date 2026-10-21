import 'package:data/compost/repository/compost_repository_impl.dart';
import 'package:domain/compost/model/compost_pit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'ticks only a full pit and stops when the compost is ready',
    () {
      final repository = CompostRepositoryImpl()..tick();

      expect(
        repository.pit.seconds,
        0,
      );

      for (var i = 0; i < CompostPit.capacity + 1; i++) {
        repository.addOrganics();
      }
      for (var i = 0; i < CompostPit.readySeconds + 10; i++) {
        repository.tick();
      }

      expect(
        repository.pit,
        const CompostPit(
          organics: CompostPit.capacity,
          seconds: CompostPit.readySeconds,
        ),
      );
      expect(
        repository.pit.isReady,
        isTrue,
      );

      repository.empty();
      expect(
        repository.pit,
        const CompostPit.empty(),
      );
    },
  );
}
