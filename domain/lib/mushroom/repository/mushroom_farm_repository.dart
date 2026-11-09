import 'package:domain/mushroom/model/mushroom_farm.dart';

abstract interface class MushroomFarmRepository {
  MushroomFarm get farm;

  Stream<MushroomFarm> get farmStream;

  void place();

  void plant();

  void tick();

  void collect();

  void restore(MushroomFarm farm);

  void reset();
}
