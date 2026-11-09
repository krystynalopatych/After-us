import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';

final class SoakCardboardUseCase {
  final BookRepository _bookRepository;
  final FeedbackRepository _feedbackRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;
  final SoundRepository _soundRepository;

  const SoakCardboardUseCase({
    required this._bookRepository,
    required this._feedbackRepository,
    required this._materialRepository,
    required this._selectionRepository,
    required this._soundRepository,
  });

  bool call() {
    if (_selectionRepository.selection.material != GameMaterial.cardboard ||
        !_materialRepository.remove(
          .cardboard,
          1,
        )) {
      return false;
    }
    _materialRepository.add(.wetCardboard);
    _bookRepository.write(.wetCardboard);
    if (_materialRepository.count(.cardboard) == 0) {
      _selectionRepository.reset();
    }
    _soundRepository.play(.pickUp);
    _feedbackRepository.show(
      const FeedbackMessage(
        text: 'You soaked cardboard in the lake +1 wet cardboard',
        mood: .happy,
      ),
    );
    return true;
  }
}
