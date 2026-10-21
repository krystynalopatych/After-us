import 'package:domain/compost/model/compost_pit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/compost/bloc/compost_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'tapping the pit with organics selected adds a pile',
    () async {
      final bloc = CompostBloc()..add(const CompostStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();
      deps.material.add(.organics);
      deps.selection.selectMaterial(.organics);

      bloc.add(const CompostPitTapped());
      await pumpEventQueue();

      expect(
        bloc.state.pit,
        const CompostPit(
          organics: 1,
          seconds: 0,
        ),
      );
    },
  );
}
