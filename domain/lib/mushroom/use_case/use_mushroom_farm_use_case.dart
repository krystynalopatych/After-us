import 'package:domain/book/repository/book_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/mushroom/repository/mushroom_farm_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';

final class UseMushroomFarmUseCase {
  final BookRepository _bookRepository;
  final ConstructionRepository _constructionRepository;
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MushroomFarmRepository _mushroomFarmRepository;
  final SelectionRepository _selectionRepository;
  final SoundRepository _soundRepository;

  const UseMushroomFarmUseCase({
    required this._bookRepository,
    required this._constructionRepository,
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._mushroomFarmRepository,
    required this._selectionRepository,
    required this._soundRepository,
  });

  void call() {
    final selection = _selectionRepository.selection;
    final slot = selection.slot;
    final stack = slot == null ? null : _inventoryRepository.stacks.elementAtOrNull(slot);
    if (selection.material == null && stack == null) {
      _collect();
      return;
    }
    if (slot == null || stack?.item != InventoryItem.mushrooms) {
      _show(const FeedbackMessage(text: 'Plant a wild mushroom on the farm'));
      return;
    }
    if (stack?.isSpoiled ?? false) {
      _show(const FeedbackMessage(text: 'This food went bad'));
      return;
    }
    _plant(slot);
  }

  void _plant(int slot) {
    if (_mushroomFarmRepository.farm.isPlanted) {
      _show(const FeedbackMessage(text: 'The farm already grows mushrooms'));
      return;
    }
    _inventoryRepository.takeAt(slot);
    _mushroomFarmRepository.plant();
    _constructionRepository.build(.mushroomFarm);
    _bookRepository.write(.mushroomFarm);
    _selectionRepository.reset();
    _soundRepository.play(.pickUp);
    _show(
      const FeedbackMessage(
        text: 'You planted a mushroom on the farm A new mushroom grows every day',
        mood: .happy,
      ),
    );
  }

  void _collect() {
    final farm = _mushroomFarmRepository.farm;
    if (!farm.isPlanted) {
      _show(const FeedbackMessage(text: 'Plant a wild mushroom on the farm'));
      return;
    }
    if (!farm.isReady) {
      _show(const FeedbackMessage(text: 'The mushroom is not ready yet'));
      return;
    }
    if (!_inventoryRepository.add(.mushrooms)) {
      _show(const FeedbackMessage(text: 'Your inventory is full'));
      return;
    }
    _mushroomFarmRepository.collect();
    _soundRepository.play(.pickUp);
    _show(
      const FeedbackMessage(
        text: 'You picked a mushroom +1 mushrooms',
        mood: .happy,
      ),
    );
  }

  void _show(FeedbackMessage message) => _feedbackRepository.show(message);
}
