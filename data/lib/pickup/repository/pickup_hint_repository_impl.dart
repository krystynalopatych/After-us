import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:domain/pickup/repository/pickup_hint_repository.dart';

final class PickupHintRepositoryImpl implements PickupHintRepository {
  final _heard = <PickupKind>{};

  @override
  Set<PickupKind> get heard => Set.unmodifiable(_heard);

  @override
  bool hear(PickupKind kind) => _heard.add(kind);

  @override
  void reset() => _heard.clear();
}
