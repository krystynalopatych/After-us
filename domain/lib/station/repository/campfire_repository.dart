import 'package:domain/station/model/campfire_uses.dart';

abstract interface class CampfireRepository {
  CampfireUses get uses;

  void use(int day);

  void restore(CampfireUses uses);

  void reset();
}
