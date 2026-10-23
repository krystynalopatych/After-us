import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/pickup/repository/pickup_hint_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';

final class NewGameUseCase {
  final BookRepository _bookRepository;
  final HeroReactionRepository _heroReactionRepository;
  final PickupHintRepository _pickupHintRepository;
  final ProgressRepository _progressRepository;

  const NewGameUseCase({
    required this._bookRepository,
    required this._heroReactionRepository,
    required this._pickupHintRepository,
    required this._progressRepository,
  });

  void call() {
    _progressRepository.reset();
    _bookRepository.reset();
    _pickupHintRepository.reset();
    _heroReactionRepository.reset();
  }
}
