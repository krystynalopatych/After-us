import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/loading/bloc/loading_bloc.dart';

void main() {
  test(
    'counts loaded images and is done when all are loaded',
    () async {
      final bloc = LoadingBloc();
      addTearDown(bloc.close);

      expect(
        bloc.state.isDone,
        isFalse,
      );

      bloc.add(const LoadingStarted(2));
      await pumpEventQueue();
      expect(
        bloc.state.progress,
        0,
      );

      bloc.add(const LoadingImageLoaded());
      await pumpEventQueue();
      expect(
        bloc.state.progress,
        0.5,
      );
      expect(
        bloc.state.isDone,
        isFalse,
      );

      bloc.add(const LoadingImageLoaded());
      await pumpEventQueue();
      expect(
        bloc.state.isDone,
        isTrue,
      );
    },
  );
}
