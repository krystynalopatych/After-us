import 'package:domain/air/model/air_quality.dart';

abstract interface class AirRepository {
  int get points;

  AirQuality get quality;

  Stream<AirQuality> get qualityStream;

  void addPoints(int points);

  void reset();
}
