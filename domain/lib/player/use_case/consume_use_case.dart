import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/model/inventory_item.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/meal_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/model/pollution_zone.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';

final class ConsumeUseCase {
  static const _pollutedValueFactor = 0.5;
  static const _freshPortionsPerDay = 2;
  static const _monotonyFactor = 0.5;

  final DayRepository _dayRepository;
  final DialogueRepository _dialogueRepository;
  final FeedbackRepository _feedbackRepository;
  final HeroReactionRepository _heroReactionRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final MealRepository _mealRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;
  final SoundRepository _soundRepository;

  const ConsumeUseCase({
    required this._dayRepository,
    required this._dialogueRepository,
    required this._feedbackRepository,
    required this._heroReactionRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._mealRepository,
    required this._playerRepository,
    required this._pollutionRepository,
    required this._soundRepository,
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
    final day = _dayRepository.day.number;
    final isMonotonous =
        !item.isDrink &&
        _mealRepository.meals.countOn(
              day,
              item,
            ) >=
            _freshPortionsPerDay;
    if (!item.isDrink) {
      _mealRepository.eat(
        item,
        day,
      );
      _soundRepository.play(.eating);
    }
    final factor = (pollutedZone != null ? _pollutedValueFactor : 1.0) * (isMonotonous ? _monotonyFactor : 1.0);
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
        isMonotonous,
        [
          if (hunger > 0) '+${_format(hunger)} hunger',
          if (thirst > 0) '+${_format(thirst)} thirst',
          if (health < 0) '−${_format(-health)} health',
          if (item.container case final container?) '+1 ${container.name}',
        ],
      ),
    );
    if (pollutedZone == .water) {
      _react(.pollutedWaterDrunk);
    }
    return true;
  }

  void _react(HeroReaction reaction) {
    if (_heroReactionRepository.hear(reaction)) {
      _dialogueRepository.say(reaction.line);
    }
  }

  static FeedbackMessage _message(
    InventoryItem item,
    PollutionZone? pollutedZone,
    bool isMonotonous,
    List<String> changes,
  ) {
    final verb = item.isDrink ? 'drank' : 'ate';
    final source = switch (pollutedZone) {
      .water => ' from the polluted lake',
      .soil => ' from polluted soil',
      null => '',
    };
    final text = [
      'You $verb ${_name(item)}$source ${changes.join(' ')}',
      if (isMonotonous) 'The same food again only half as filling',
    ].join('\n');
    return switch (pollutedZone) {
      .water => FeedbackMessage(
        text: text,
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
