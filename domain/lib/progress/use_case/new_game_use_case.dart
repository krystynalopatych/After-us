import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';

final class NewGameUseCase {
  final BookRepository _bookRepository;
  final ProgressRepository _progressRepository;

  const NewGameUseCase({
    required this._bookRepository,
    required this._progressRepository,
  });

  void call() {
    _progressRepository.reset();
    _bookRepository.reset();
  }
}
