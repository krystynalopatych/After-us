import 'package:domain/sun_spot/model/sun_bottle.dart';

abstract interface class SunSpotRepository {
  SunBottle? get bottle;

  Stream<SunBottle?> get bottleStream;

  void place(SunBottle bottle);

  void tick();

  void take();

  void restore(SunBottle? bottle);

  void reset();
}
