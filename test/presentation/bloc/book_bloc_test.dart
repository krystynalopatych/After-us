import 'package:domain/book/model/book_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation/feature/book/bloc/book_bloc.dart';

import '../../helpers/test_dependencies.dart';

void main() {
  late TestDependencies deps;

  setUp(() async {
    deps = TestDependencies();
    await deps.register();
  });

  test(
    'opening the book shows the records and marks them as read',
    () async {
      deps.book
        ..write(.waterFilter)
        ..write(.soakedAlgae);
      final bloc = BookBloc()..add(const BookStarted());
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state.records,
        [BookRecord.waterFilter, BookRecord.soakedAlgae],
      );
      expect(
        deps.book.book.hasNewRecord,
        isFalse,
      );
    },
  );
}
