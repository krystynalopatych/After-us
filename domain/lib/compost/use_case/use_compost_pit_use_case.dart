import 'package:domain/compost/model/compost_pit.dart';
import 'package:domain/compost/repository/compost_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';

final class UseCompostPitUseCase {
  static const _organicsPerPile = 1;

  final CompostRepository _compostRepository;
  final FeedbackRepository _feedbackRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;

  const UseCompostPitUseCase({
    required this._compostRepository,
    required this._feedbackRepository,
    required this._materialRepository,
    required this._selectionRepository,
  });

  bool call() {
    final pit = _compostRepository.pit;
    if (pit.isReady) {
      for (var i = 0; i < CompostPit.compostYield; i++) {
        _materialRepository.add(.compost);
      }
      _compostRepository.empty();
      _show(
        const FeedbackMessage(
          text: 'You took the compost +${CompostPit.compostYield} compost',
          mood: .happy,
        ),
      );
      return true;
    }
    if (pit.isFull) {
      _show(const FeedbackMessage(text: 'The compost is not ready yet'));
      return false;
    }
    final selection = _selectionRepository.selection;
    if (selection.material == null && selection.slot == null) {
      return false;
    }
    if (selection.material != GameMaterial.organics) {
      _show(const FeedbackMessage(text: 'Only organics can go in the compost pit'));
      return false;
    }
    _materialRepository.remove(
      .organics,
      _organicsPerPile,
    );
    _compostRepository.addOrganics();
    if (_materialRepository.count(.organics) == 0) {
      _selectionRepository.reset();
    }
    final organics = _compostRepository.pit.organics;
    _show(
      FeedbackMessage(
        text: organics < CompostPit.capacity
            ? 'You put organics in the pit $organics/${CompostPit.capacity}'
            : 'The pit is full the compost will be ready in a day',
      ),
    );
    return true;
  }

  void _show(FeedbackMessage message) => _feedbackRepository.show(message);
}
