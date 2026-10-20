import 'package:domain/material/model/game_material.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/model/station_choice.dart';
import 'package:domain/station/use_case/build_station_use_case.dart';
import 'package:domain/station/use_case/station_choices_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;
  late StationChoicesUseCase stationChoices;
  late BuildStationUseCase buildStation;

  setUp(() {
    deps = TestDependencies();
    stationChoices = StationChoicesUseCase(
      materialRepository: deps.material,
      selectionRepository: deps.selection,
      stationRepository: deps.station,
    );
    buildStation = BuildStationUseCase(
      materialRepository: deps.material,
      selectionRepository: deps.selection,
      stationRepository: deps.station,
    );
  });

  group(
    'StationChoicesUseCase',
    () {
      test(
        'offers nothing without a selected material',
        () {
          deps.material.add(.wood);

          expect(
            stationChoices(),
            isEmpty,
          );
        },
      );

      test(
        'offers nothing for a material that builds no station',
        () {
          deps.material.add(.plastic);
          deps.selection.selectMaterial(.plastic);

          expect(
            stationChoices(),
            isEmpty,
          );
        },
      );

      test(
        'offers the campfire and the workbench for wood',
        () {
          deps.material.add(.wood);
          deps.selection.selectMaterial(.wood);

          expect(
            stationChoices(),
            const [
              StationChoice(
                station: .campfire,
                isBuilt: false,
                isAffordable: true,
              ),
              StationChoice(
                station: .workbench,
                isBuilt: false,
                isAffordable: true,
              ),
            ],
          );
        },
      );

      test(
        'marks built stations and stations the player cannot afford',
        () {
          deps.station.build(.campfire);
          deps.selection.selectMaterial(.wood);

          final choices = stationChoices();

          expect(
            choices.first.isBuilt,
            isTrue,
          );
          expect(
            choices.first.canBuild,
            isFalse,
          );
          expect(
            choices.last.isAffordable,
            isFalse,
          );
          expect(
            choices.last.canBuild,
            isFalse,
          );
        },
      );
    },
  );

  group(
    'BuildStationUseCase',
    () {
      test(
        'builds a station for one wood',
        () {
          deps.material
            ..add(.wood)
            ..add(.wood);
          deps.selection.selectMaterial(.wood);

          expect(
            buildStation(.campfire),
            isTrue,
          );
          expect(
            deps.station.built,
            {Station.campfire},
          );
          expect(
            deps.material.count(.wood),
            1,
          );
          expect(
            deps.selection.selection.material,
            GameMaterial.wood,
          );
        },
      );

      test(
        'clears the selection when the last wood is spent',
        () {
          deps.material.add(.wood);
          deps.selection.selectMaterial(.wood);

          buildStation(.workbench);

          expect(
            deps.material.count(.wood),
            0,
          );
          expect(
            deps.selection.selection.material,
            isNull,
          );
        },
      );

      test(
        'does not build without wood',
        () {
          expect(
            buildStation(.campfire),
            isFalse,
          );
          expect(
            deps.station.built,
            isEmpty,
          );
        },
      );

      test(
        'does not build the same station twice or spend wood on it',
        () {
          deps.material
            ..add(.wood)
            ..add(.wood);
          buildStation(.campfire);

          expect(
            buildStation(.campfire),
            isFalse,
          );
          expect(
            deps.material.count(.wood),
            1,
          );
        },
      );
    },
  );
}
