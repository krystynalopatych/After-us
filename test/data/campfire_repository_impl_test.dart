import 'package:data/station/repository/campfire_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'counts campfires per day and starts again on a new day',
    () {
      final repository = CampfireRepositoryImpl()
        ..use(1)
        ..use(1);

      expect(
        repository.uses.countOn(1),
        2,
      );

      repository.use(2);

      expect(
        repository.uses.countOn(1),
        0,
      );
      expect(
        repository.uses.countOn(2),
        1,
      );
    },
  );
}
