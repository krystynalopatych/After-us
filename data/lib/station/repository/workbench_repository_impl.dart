import 'dart:async';

import 'package:domain/station/model/workbench_item.dart';
import 'package:domain/station/repository/workbench_repository.dart';

final class WorkbenchRepositoryImpl implements WorkbenchRepository {
  static const _slotCount = 4;

  final _slotsController = StreamController<List<WorkbenchItem?>>.broadcast();
  final _slots = List<WorkbenchItem?>.filled(
    _slotCount,
    null,
  );

  @override
  List<WorkbenchItem?> get slots => List.unmodifiable(_slots);

  @override
  Stream<List<WorkbenchItem?>> get slotsStream => _slotsController.stream;

  @override
  void setSlot(
    int index,
    WorkbenchItem? item,
  ) {
    _slots[index] = item;
    _slotsController.add(slots);
  }

  @override
  void reset() {
    _slots.fillRange(
      0,
      _slotCount,
      null,
    );
    _slotsController.add(slots);
  }
}
