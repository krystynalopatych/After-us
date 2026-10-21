import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/lake/bloc/lake_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'the lake turns dark when the water gets polluted',
    () async {
      final bloc = LakeBloc()..add(const LakeStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state.isPolluted,
        isFalse,
      );

      deps.pollution.polluteWater();
      await pumpEventQueue();

      expect(
        bloc.state.isPolluted,
        isTrue,
      );
    },
  );
}
