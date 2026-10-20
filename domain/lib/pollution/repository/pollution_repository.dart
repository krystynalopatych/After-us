import 'package:domain/pollution/model/pollution.dart';

abstract interface class PollutionRepository {
  Pollution get pollution;

  Stream<Pollution> get pollutionStream;

  void addAirPoints(int points);

  void polluteWater();

  void polluteSoil();

  void restore(Pollution pollution);

  void reset();
}
