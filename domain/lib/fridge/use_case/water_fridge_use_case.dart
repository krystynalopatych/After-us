import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';

final class WaterFridgeUseCase {
  final DayRepository _dayRepository;
  final FeedbackRepository _feedbackRepository;
  final FridgeRepository _fridgeRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;
  final SoundRepository _soundRepository;

  const WaterFridgeUseCase({
    required this._dayRepository,
    required this._feedbackRepository,
    required this._fridgeRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
    required this._soundRepository,
  });

  bool call() {
    final item = switch (_selectionRepository.selection.slot) {
      final index? => _inventoryRepository.stacks.elementAtOrNull(index)?.item,
      null => null,
    };
    if (item == null || item.water == null) {
      return false;
    }
    final day = _dayRepository.day.number;
    if (item.water != .lake) {
      _show('Use lake water for the fridge');
      return true;
    }
    if (_fridgeRepository.fridge.isCoolingOn(day)) {
      _show('The fridge is already watered today');
      return true;
    }
    final isTaken = switch (item.emptyBottle) {
      final emptyBottle? => _inventoryRepository.replace(
        item,
        [emptyBottle],
      ),
      null => _inventoryRepository.remove(item),
    };
    if (!isTaken) {
      return true;
    }
    if (item.container case final container?) {
      _materialRepository.add(container);
    }
    _fridgeRepository.water(day);
    _selectionRepository.reset();
    _soundRepository.play(.pickUp);
    _feedbackRepository.show(
      FeedbackMessage(
        text: [
          'You watered the fridge Food stays fresh today',
          if (item.container case final container?) '+1 ${container.name}',
        ].join(' '),
        mood: .happy,
      ),
    );
    return true;
  }

  void _show(String text) => _feedbackRepository.show(FeedbackMessage(text: text));
}
