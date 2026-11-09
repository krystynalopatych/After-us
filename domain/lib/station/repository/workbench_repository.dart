import 'package:domain/station/model/workbench_item.dart';

abstract interface class WorkbenchRepository {
  List<WorkbenchItem?> get slots;

  Stream<List<WorkbenchItem?>> get slotsStream;

  void setSlot(
    int index,
    WorkbenchItem? item,
  );

  void reset();
}
