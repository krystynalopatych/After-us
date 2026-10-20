import 'package:domain/station/model/station.dart';

abstract interface class StationRepository {
  Set<Station> get built;

  Stream<Set<Station>> get builtStream;

  void build(Station station);

  void restore(Set<Station> built);

  void reset();
}
