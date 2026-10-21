import 'dart:async';

import 'package:domain/book/model/book.dart';
import 'package:domain/book/model/book_record.dart';
import 'package:domain/book/repository/book_repository.dart';

final class BookRepositoryImpl implements BookRepository {
  final _bookController = StreamController<Book>.broadcast();
  Book _book = const .empty();

  @override
  Book get book => _book;

  @override
  Stream<Book> get bookStream => _bookController.stream;

  @override
  bool write(BookRecord record) {
    if (_book.records.contains(record)) {
      return false;
    }
    _update(
      _book.copyWith(
        records: List.unmodifiable([
          ..._book.records,
          record,
        ]),
        hasNewRecord: true,
      ),
    );
    return true;
  }

  @override
  void markRead() => _update(_book.copyWith(hasNewRecord: false));

  @override
  void reset() => _update(const .empty());

  void _update(Book book) {
    _book = book;
    _bookController.add(book);
  }
}
