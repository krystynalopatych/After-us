import 'package:domain/book/repository/book_repository.dart';

final class ReadBookUseCase {
  final BookRepository _bookRepository;

  const ReadBookUseCase({required this._bookRepository});

  void call() => _bookRepository.markRead();
}
