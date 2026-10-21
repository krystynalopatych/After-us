import 'package:domain/station/model/station.dart';
import 'package:domain/station/use_case/place_station_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late PlaceStationUseCase placeStation;

  setUp(() {
    deps = TestDependencies();
    placeStation = PlaceStationUseCase(
      feedbackRepository: deps.feedback,
      inventoryRepository: deps.inventory,
      selectionRepository: deps.selection,
      stationRepository: deps.station,
    );
  });

  test(
    'sets up the selected rocket stove at the house',
    () {
      deps.inventory.add(.rocketStove);
      deps.selection.selectSlot(0);

      expect(
        placeStation(),
        isTrue,
      );
      expect(
        deps.station.built,
        {Station.rocketStove},
      );
      expect(
        deps.inventory.count(.rocketStove),
        0,
      );
      expect(
        deps.selection.selection.slot,
        isNull,
      );
    },
  );

  test(
    'does nothing for other items or without a selection',
    () {
      deps.inventory.add(.cookingPot);

      expect(
        placeStation(),
        isFalse,
      );
      deps.selection.selectSlot(0);
      expect(
        placeStation(),
        isFalse,
      );
      expect(
        deps.station.built,
        isEmpty,
      );
    },
  );
}
