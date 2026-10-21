import 'package:domain/compost/model/compost_pit.dart';

abstract interface class CompostRepository {
  CompostPit get pit;

  Stream<CompostPit> get pitStream;

  void addOrganics();

  void tick();

  void empty();

  void restore(CompostPit pit);

  void reset();
}
