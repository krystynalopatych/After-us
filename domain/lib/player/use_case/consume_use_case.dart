import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/model/pollution_zone.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';

final class ConsumeUseCase {
  static const _pollutedValueFactor = 0.5;

  final FeedbackRepository _feedbackRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;

  const ConsumeUseCase({
    required this._feedbackRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._playerRepository,
    required this._pollutionRepository,
  });

  bool call(InventoryItem item) {
    if (!item.isConsumable || _inventoryRepository.count(item) == 0) {
      return false;
    }
    final isTaken = switch (item.emptyBottle) {
      final emptyBottle? => _inventoryRepository.replace(
        item,
        [emptyBottle],
      ),
      null => _inventoryRepository.remove(item),
    };
    if (!isTaken) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Your inventory is full'));
      return false;
    }
    final pollutedZone = switch (item.zone) {
      final zone? when _pollutionRepository.pollution.isPolluted(zone) => zone,
      _ => null,
    };
    final factor = pollutedZone != null ? _pollutedValueFactor : 1.0;
    final hunger = item.hunger * factor;
    final thirst = item.thirst * factor;
    final health = item.health - (pollutedZone?.healthPenalty ?? 0);
    if (item.container case final container?) {
      _materialRepository.add(container);
    }
    final stats = _playerRepository.stats;
    _playerRepository.setStats(
      stats.copyWith(
        health: (stats.health + health).clamp(
          0.0,
          stats.healthCeiling,
        ),
        hunger: (stats.hunger + hunger).clamp(
          0.0,
          PlayerStats.maxNeed,
        ),
        thirst: (stats.thirst + thirst).clamp(
          0.0,
          PlayerStats.maxNeed,
        ),
      ),
    );
    _feedbackRepository.show(
      _message(
        item,
        pollutedZone,
        [
          if (hunger > 0) '+${_format(hunger)} hunger',
          if (thirst > 0) '+${_format(thirst)} thirst',
          if (health < 0) '−${_format(-health)} health',
          if (item.container case final container?) '+1 ${container.name}',
        ],
      ),
    );
    return true;
  }

  static FeedbackMessage _message(
    InventoryItem item,
    PollutionZone? pollutedZone,
    List<String> changes,
  ) {
    final verb = item.isDrink ? 'drank' : 'ate';
    final source = switch (pollutedZone) {
      .water => ' from the polluted lake',
      .soil => ' from polluted soil',
      null => '',
    };
    final text = 'You $verb ${_name(item)}$source ${changes.join(' ')}';
    return switch (pollutedZone) {
      .water => FeedbackMessage(
        text: text,
        heroLine: 'Ugh... The lake is poisoned now.',
        mood: .sad,
      ),
      .soil => FeedbackMessage(
        text: text,
        heroLine: 'My stomach... This soil is poisoned.',
        mood: .sad,
      ),
      null when item.health < 0 => FeedbackMessage(
        text: text,
        heroLine: 'It tastes like mud. I need clean water.',
        mood: .sad,
      ),
      null => FeedbackMessage(
        text: text,
        mood: .happy,
      ),
    };
  }

  static String _format(double value) =>
      value == value.roundToDouble() ? value.round().toString() : value.toStringAsFixed(1);

  static String _name(InventoryItem item) => switch (item) {
    .cattailRoot => 'cattail roots',
    .cattailRootCooked => 'cooked cattail roots',
    .algae => 'algae',
    .algaeSoaked => 'soaked algae',
    .berries => 'berries',
    .cleanWater || .sodisCleanWater => 'clean water',
    .sodisLakeWater || .bottleLakeWater => 'lake water',
    .sodisStrainedWater || .bottleStrainedWater => 'strained water',
    .sodisFilteredWater || .bottleFilteredWater => 'filtered water',
    .sodisBottle => 'a SODIS bottle',
    .prefilter => 'a cloth prefilter',
    .cookingPot => 'a cooking pot',
    .rocketStove => 'a rocket stove',
    .waterFilter => 'a water filter',
  };
}
