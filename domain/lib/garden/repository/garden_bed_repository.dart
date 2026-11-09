import 'package:domain/garden/model/garden_bed.dart';

abstract interface class GardenBedRepository {
  GardenBed get bed;

  Stream<GardenBed> get bedStream;

  void place();

  void plant();

  void addGreenhouse();

  void fertilize();

  void tick();

  void harvest();

  void restore(GardenBed bed);

  void reset();
}
