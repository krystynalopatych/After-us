import 'package:domain/station/model/campfire_uses.dart';
import 'package:domain/station/repository/campfire_repository.dart';

final class CampfireRepositoryImpl implements CampfireRepository {
  CampfireUses _uses = const .none();

  @override
  CampfireUses get uses => _uses;

  @override
  void use(int day) => _uses = CampfireUses(
    day: day,
    count: _uses.countOn(day) + 1,
  );

  @override
  void restore(CampfireUses uses) => _uses = uses;

  @override
  void reset() => _uses = const .none();
}
