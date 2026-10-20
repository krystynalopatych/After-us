import 'package:domain/station/model/station.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/station/bloc/station_bloc.dart';
import 'package:presentation/feature/station/bloc/station_build_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  group(
    'StationBloc',
    () {
      test(
        'shows the stored stations and follows new ones',
        () async {
          deps.station.build(.workbench);
          final bloc = StationBloc()..add(const StationStarted());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expect(
            bloc.state.built,
            {Station.workbench},
          );

          deps.station.build(.campfire);
          await pumpEventQueue();

          expect(
            bloc.state.built,
            {Station.workbench, Station.campfire},
          );
        },
      );
    },
  );

  group(
    'StationBuildBloc',
    () {
      test(
        'loads the choices for the selected material',
        () async {
          deps.material.add(.wood);
          deps.selection.selectMaterial(.wood);
          final bloc = StationBuildBloc()..add(const StationBuildStarted());
          addTearDown(bloc.close);
          await pumpEventQueue();

          expect(
            bloc.state.choices.map((choice) => choice.station),
            [Station.campfire, Station.workbench],
          );
        },
      );

      test(
        'tapping a choice builds the station',
        () async {
          deps.material.add(.wood);
          deps.selection.selectMaterial(.wood);
          final bloc = StationBuildBloc()..add(const StationBuildStarted());
          addTearDown(bloc.close);
          await pumpEventQueue();

          bloc.add(const StationBuildTapped(.workbench));
          await pumpEventQueue();

          expect(
            deps.station.built,
            {Station.workbench},
          );
          expect(
            deps.material.count(.wood),
            0,
          );
        },
      );
    },
  );
}
