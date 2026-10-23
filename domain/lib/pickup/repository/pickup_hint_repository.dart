import 'package:domain/pickup/model/pickup_kind.dart';

abstract interface class PickupHintRepository {
  Set<PickupKind> get heard;

  bool hear(PickupKind kind);

  void reset();
}
