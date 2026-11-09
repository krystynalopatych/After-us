import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/garden/model/garden_bed.dart';
import 'package:domain/garden/repository/garden_bed_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';

final class UseGardenBedUseCase {
  final ConstructionRepository _constructionRepository;
  final DayRepository _dayRepository;
  final FeedbackRepository _feedbackRepository;
  final GardenBedRepository _gardenBedRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final SelectionRepository _selectionRepository;
  final SoundRepository _soundRepository;

  const UseGardenBedUseCase({
    required this._constructionRepository,
    required this._dayRepository,
    required this._feedbackRepository,
    required this._gardenBedRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._selectionRepository,
    required this._soundRepository,
  });

  void call() {
    final selection = _selectionRepository.selection;
    final stack = switch (selection.slot) {
      final slot? => _inventoryRepository.stacks.elementAtOrNull(slot),
      null => null,
    };
    switch ((selection.material, stack?.item)) {
      case (GameMaterial.seeds, _):
        _plant();
      case (_, final item?) when item.isPerishable && (stack?.isSpoiled ?? false):
        _feedSpoiled(selection.slot);
      case (_, InventoryItem.greenhouse):
        _addGreenhouse();
      case (_, InventoryItem.algae) when !(stack?.isSpoiled ?? false):
        _fertilize(selection.slot);
      case (null, null):
        _harvest();
      case _:
        _show(const FeedbackMessage(text: "You can't use this on the garden bed"));
    }
  }

  void _plant() {
    if (_gardenBedRepository.bed.isPlanted) {
      _show(const FeedbackMessage(text: 'The seeds are already planted'));
      return;
    }
    _materialRepository.remove(
      .seeds,
      1,
    );
    _gardenBedRepository.plant();
    if (_materialRepository.count(.seeds) == 0) {
      _selectionRepository.reset();
    }
    final bed = _gardenBedRepository.bed;
    _show(
      FeedbackMessage(
        text: bed.isPlanted
            ? 'The seeds are planted potatoes grow in ${bed.hasGreenhouse ? 'half a day' : 'a day'}'
            : 'You planted a seed ${bed.seeds}/${GardenBed.seedsNeeded}',
        mood: bed.isPlanted ? .happy : .normal,
      ),
    );
    _completeGoal();
  }

  void _addGreenhouse() {
    if (_gardenBedRepository.bed.hasGreenhouse) {
      _show(const FeedbackMessage(text: 'The bed already has a greenhouse'));
      return;
    }
    _inventoryRepository.remove(.greenhouse);
    _gardenBedRepository.addGreenhouse();
    _selectionRepository.reset();
    _soundRepository.play(.pickUp);
    _show(
      const FeedbackMessage(
        text: 'You put the greenhouse over the bed Food grows twice as fast',
        mood: .happy,
      ),
    );
    _completeGoal();
  }

  void _fertilize(int? slot) {
    final bed = _gardenBedRepository.bed;
    if (!bed.isPlanted) {
      _show(const FeedbackMessage(text: 'Plant the seeds first'));
      return;
    }
    if (bed.isFertilized) {
      _show(const FeedbackMessage(text: 'The bed is already fertilized'));
      return;
    }
    if (slot == null || _inventoryRepository.takeAt(slot) == null) {
      return;
    }
    _gardenBedRepository.fertilize();
    _selectionRepository.reset();
    _show(
      const FeedbackMessage(
        text: 'You fed the bed with algae +${GardenBed.fertilizerBonus} potato next time',
        mood: .happy,
      ),
    );
  }

  void _feedSpoiled(int? slot) {
    final bed = _gardenBedRepository.bed;
    final day = _dayRepository.day.number;
    if (!bed.isPlanted || bed.isReady) {
      _show(const FeedbackMessage(text: 'Spoiled food helps only while potatoes grow'));
      return;
    }
    if (bed.boostedDay == day) {
      _show(const FeedbackMessage(text: 'The bed was already fed today'));
      return;
    }
    if (slot == null || _inventoryRepository.takeAt(slot) == null) {
      return;
    }
    _gardenBedRepository.boost(day);
    _selectionRepository.reset();
    _show(
      const FeedbackMessage(
        text: 'You fed the bed with spoiled food The potatoes grow faster',
        mood: .happy,
      ),
    );
  }

  void _harvest() {
    final bed = _gardenBedRepository.bed;
    if (!bed.isPlanted) {
      _show(const FeedbackMessage(text: 'Plant ${GardenBed.seedsNeeded} seeds here'));
      return;
    }
    if (!bed.isReady) {
      _show(const FeedbackMessage(text: 'The potatoes are not ready yet'));
      return;
    }
    if (!_inventoryRepository.exchange(
      const [],
      List.filled(
        bed.harvestCount,
        InventoryItem.potato,
      ),
    )) {
      _show(const FeedbackMessage(text: 'Your inventory is full'));
      return;
    }
    _gardenBedRepository.harvest();
    _soundRepository.play(.pickUp);
    _show(
      FeedbackMessage(
        text: 'You dug up potatoes +${bed.harvestCount} potatoes',
        mood: .happy,
      ),
    );
  }

  void _completeGoal() {
    if (_gardenBedRepository.bed.isComplete) {
      _constructionRepository.build(.gardenBed);
    }
  }

  void _show(FeedbackMessage message) => _feedbackRepository.show(message);
}
