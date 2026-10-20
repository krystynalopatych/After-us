import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';

final class FillBottleUseCase {
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;

  const FillBottleUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
  });

  bool call() {
    if (_inventoryRepository.count(.sodisBottle) == 0) {
      _feedbackRepository.show(const FeedbackMessage(text: 'You need a SODIS bottle to carry lake water.'));
      return false;
    }
    if (!_inventoryRepository.add(.lakeWater)) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Your inventory is full.'));
      return false;
    }
    _feedbackRepository.show(
      const FeedbackMessage(
        text: 'You filled a bottle with lake water.',
        heroLine: 'Drinking it as is will make me sick.',
      ),
    );
    return true;
  }
}
