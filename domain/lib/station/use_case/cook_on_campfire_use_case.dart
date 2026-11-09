import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/sound/repository/sound_repository.dart';
import 'package:domain/station/model/campfire_fuel.dart';
import 'package:domain/station/model/campfire_recipe.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/repository/fire_repository.dart';
import 'package:domain/station/repository/campfire_repository.dart';

final class CookOnCampfireUseCase {
  static const _fuelCount = 1;
  static const _smokelessCampfiresPerDay = 2;
  static const _smokeAirPoints = 1;

  final CampfireRepository _campfireRepository;
  final DayRepository _dayRepository;
  final FireRepository _fireRepository;
  final DialogueRepository _dialogueRepository;
  final FeedbackRepository _feedbackRepository;
  final HeroReactionRepository _heroReactionRepository;
  final InventoryRepository _inventoryRepository;
  final MaterialRepository _materialRepository;
  final PollutionRepository _pollutionRepository;
  final SelectionRepository _selectionRepository;
  final SoundRepository _soundRepository;

  const CookOnCampfireUseCase({
    required this._campfireRepository,
    required this._dayRepository,
    required this._fireRepository,
    required this._dialogueRepository,
    required this._feedbackRepository,
    required this._heroReactionRepository,
    required this._inventoryRepository,
    required this._materialRepository,
    required this._pollutionRepository,
    required this._selectionRepository,
    required this._soundRepository,
  });

  bool call(
    CampfireRecipe recipe,
    CampfireFuel fuel,
    Station station,
  ) {
    if (_fireRepository.recipe != recipe || _materialRepository.count(fuel.material) < _fuelCount) {
      return false;
    }
    if (recipe.input != null &&
        !_inventoryRepository.exchange(
          const [],
          recipe.outputsOn(station),
        )) {
      _feedbackRepository.show(const FeedbackMessage(text: 'Your inventory is full'));
      return false;
    }
    _materialRepository.remove(
      fuel.material,
      _fuelCount,
    );
    _fireRepository.reset();
    if (recipe.input?.container case final container?) {
      _materialRepository.add(container);
    }
    if (recipe.product case final product?) {
      _materialRepository.add(product);
    }
    final isCampfire = station == .campfire;
    final isPolluting = isCampfire && fuel.isPolluting;
    if (isPolluting) {
      _pollutionRepository.addAirPoints(fuel.airPoints);
    }
    final day = _dayRepository.day.number;
    final isSmoky = isCampfire && _campfireRepository.uses.countOn(day) >= _smokelessCampfiresPerDay;
    if (isCampfire) {
      _campfireRepository.use(day);
    }
    if (isSmoky) {
      _pollutionRepository.addAirPoints(_smokeAirPoints);
    }
    _selectionRepository.reset();
    _soundRepository.play(.pickUp);
    _feedbackRepository.show(
      _message(
        recipe,
        fuel,
        recipe.outputCountOn(station),
        isPolluting: isPolluting,
        isSmoky: isSmoky,
      ),
    );
    if (fuel.burnReaction case final reaction? when isPolluting) {
      _react(reaction);
    }
    if (isSmoky) {
      _react(.tooManyFires);
    }
    return true;
  }

  void _react(HeroReaction reaction) {
    if (_heroReactionRepository.hear(reaction)) {
      _dialogueRepository.say(reaction.line);
    }
  }

  static FeedbackMessage _message(
    CampfireRecipe recipe,
    CampfireFuel fuel,
    int count, {
    required bool isPolluting,
    required bool isSmoky,
  }) {
    final text = switch (recipe) {
      .boilSodisLakeWater || .boilSodisStrainedWater => 'You boiled water +$count clean water',
      .boilBottleLakeWater || .boilBottleStrainedWater => 'You boiled water +$count clean water +1 plastic',
      .cookCattailRoot => 'You cooked cattail roots +$count cooked cattail roots',
      .cookMushrooms => 'You cooked mushrooms +$count cooked mushrooms',
      .boilPotato => 'You boiled potatoes +$count boiled potatoes',
      .makeCharcoal => 'You made charcoal +1 charcoal',
      .fireClayPot => 'You fired a clay pot +1 clay pot',
    };
    if (isPolluting || isSmoky) {
      return FeedbackMessage(
        text: [
          text,
          if (isPolluting) 'You burned ${fuel.name} Air quality −${fuel.airPoints}',
          if (isSmoky) 'Too many fires today Air quality −$_smokeAirPoints',
        ].join('\n'),
        mood: .sad,
      );
    }
    return FeedbackMessage(
      text: text,
      heroLine: switch (recipe) {
        .boilSodisLakeWater ||
        .boilBottleLakeWater ||
        .boilSodisStrainedWater ||
        .boilBottleStrainedWater => "Now it's safe to drink.",
        .cookCattailRoot => 'Warm food at last.',
        .cookMushrooms => 'Boiled mushrooms. Much safer than raw.',
        .boilPotato => 'Potatoes I grew myself. They taste like hope.',
        .makeCharcoal => 'Charcoal... I can use it for the water filter.',
        .fireClayPot => 'A real pot! Two of them and some wet sand make a fridge.',
      },
      mood: .happy,
    );
  }
}
