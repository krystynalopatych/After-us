import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sun_spot/model/sun_bottle.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';

final class UseSunSpotUseCase {
  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final SelectionRepository _selectionRepository;
  final SunSpotRepository _sunSpotRepository;

  const UseSunSpotUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._selectionRepository,
    required this._sunSpotRepository,
  });

  bool call() {
    if (_sunSpotRepository.bottle case final bottle?) {
      return _take(bottle);
    }
    final item = switch (_selectionRepository.selection.slot) {
      final slot? => _inventoryRepository.stacks.elementAtOrNull(slot)?.item,
      null => null,
    };
    if (item == null) {
      return false;
    }
    final problem = switch (item) {
      InventoryItem(bottle: .sodis, water: final water?) when water.isClean => 'This water is already ok',
      InventoryItem(bottle: .sodis, water: _?) => null,
      _ => 'Only a SODIS bottle with water can go in the sun',
    };
    if (problem != null) {
      _feedbackRepository.show(FeedbackMessage(text: problem));
      return false;
    }
    _inventoryRepository.remove(item);
    _sunSpotRepository.place(SunBottle(item: item));
    _selectionRepository.reset();
    _feedbackRepository.show(const FeedbackMessage(text: 'You left the SODIS bottle in the sun'));
    return true;
  }

  bool _take(SunBottle bottle) {
    if (!bottle.isReady) {
      return false;
    }
    if (!_inventoryRepository.add(bottle.result)) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Your inventory is full'));
      return false;
    }
    _sunSpotRepository.take();
    final isCleaned = bottle.result != bottle.item;
    _feedbackRepository.show(
      FeedbackMessage(
        text: isCleaned ? 'The water in the bottle is clean' : 'The sun could not clean muddy water',
        mood: isCleaned ? .happy : .sad,
      ),
    );
    return true;
  }
}
