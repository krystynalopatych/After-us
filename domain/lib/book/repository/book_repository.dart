import 'package:domain/book/model/book.dart';
import 'package:domain/book/model/book_record.dart';

abstract interface class BookRepository {
  Book get book;

  Stream<Book> get bookStream;

  bool write(BookRecord record);

  void markRead();

  void reset();
}
