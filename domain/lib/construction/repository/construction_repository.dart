import 'package:domain/construction/model/construction.dart';

abstract interface class ConstructionRepository {
  Set<Construction> get built;

  Stream<Set<Construction>> get builtStream;

  void build(Construction construction);

  void restore(Set<Construction> built);

  void reset();
}
