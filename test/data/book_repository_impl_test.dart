import 'package:data/book/repository/book_repository_impl.dart';
import 'package:domain/book/model/book.dart';
import 'package:domain/book/model/book_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'writes each record once in order, flags it as new until read',
    () {
      final repository = BookRepositoryImpl();

      expect(
        repository.write(.sodisBottle),
        isTrue,
      );
      expect(
        repository.write(.cookingPot),
        isTrue,
      );
      expect(
        repository.write(.sodisBottle),
        isFalse,
      );
      expect(
        repository.book,
        const Book(
          records: [BookRecord.sodisBottle, BookRecord.cookingPot],
          hasNewRecord: true,
        ),
      );

      repository.markRead();
      expect(
        repository.book.hasNewRecord,
        isFalse,
      );

      repository.reset();
      expect(
        repository.book,
        const Book.empty(),
      );
    },
  );
}
