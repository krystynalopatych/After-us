import 'dart:math';

import 'package:domain/compost/repository/compost_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/model/game_day.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/day/repository/clock_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/player/model/player_stats.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';

final class PassSecondUseCase {
  static const _hungerPerDay = 40.0;
  static const _thirstPerDay = 60.0;
  static const _starvingHealthPerDay = 25.0;
  static const _dehydratedHealthPerDay = 35.0;
  static const _recoveryHealthPerDay = 10.0;
  static const _wellFedLevel = 50.0;
  static const _weakHealthLevel = 30.0;
  static const _weakDropMultiplier = 1.5;

  final ClockRepository _clockRepository;
  final CompostRepository _compostRepository;
  final ConstructionRepository _constructionRepository;
  final DayRepository _dayRepository;
  final DialogueRepository _dialogueRepository;
  final FeedbackRepository _feedbackRepository;
  final HeroReactionRepository _heroReactionRepository;
  final PlayerRepository _playerRepository;
  final PollutionRepository _pollutionRepository;
  final SunSpotRepository _sunSpotRepository;

  const PassSecondUseCase({
    required this._clockRepository,
    required this._compostRepository,
    required this._constructionRepository,
    required this._dayRepository,
    required this._dialogueRepository,
    required this._feedbackRepository,
    required this._heroReactionRepository,
    required this._playerRepository,
    required this._pollutionRepository,
    required this._sunSpotRepository,
  });

  void call(GameLevel level) {
    if (_dayRepository.outcome != null || _clockRepository.isPaused) {
      return;
    }
    final today = _dayRepository.day;
    if (today.isNight) {
      _dayRepository.setDay(today.copyWith(nightSeconds: today.nightSeconds - 1));
      return;
    }
    if (_playerRepository.stats.health <= 0) {
      _dayRepository.setOutcome(.died);
      return;
    }
    var stats = _secondStats(_playerRepository.stats);
    var day = today.copyWith(seconds: today.seconds + 1);
    LevelOutcome? outcome;

    if (day.isOver) {
      stats = _endOfDayStats(stats);
      if (day.number >= level.days) {
        outcome = _constructionRepository.built.containsAll(level.goals) ? .won : .noTimeLeft;
      } else {
        day = GameDay(
          number: day.number + 1,
          seconds: 0,
          nightSeconds: GameDay.nightLength,
        );
      }
    }
    if (stats.health <= 0) {
      outcome = .died;
    }

    _playerRepository.setStats(stats);
    _dayRepository.setDay(day);
    _sunSpotRepository.tick();
    _tickCompost();
    if (_pollutionRepository.pollution.airQuality == .polluted) {
      _react(.darkSky);
    }
    if (outcome != null) {
      _dayRepository.setOutcome(outcome);
    }
  }

  PlayerStats _secondStats(PlayerStats stats) {
    final multiplier = stats.health < _weakHealthLevel ? _weakDropMultiplier : 1.0;
    final hunger = max(
      0.0,
      stats.hunger - _perSecond(_hungerPerDay) * multiplier,
    );
    final thirst = max(
      0.0,
      stats.thirst - _perSecond(_thirstPerDay) * multiplier,
    );
    final health =
        stats.health +
        _healthChange(
          hunger,
          thirst,
        );
    return stats.copyWith(
      health: health.clamp(
        0.0,
        stats.healthCeiling,
      ),
      hunger: hunger,
      thirst: thirst,
    );
  }

  double _healthChange(
    double hunger,
    double thirst,
  ) {
    var change = 0.0;
    if (hunger <= 0) {
      change -= _perSecond(_starvingHealthPerDay);
    }
    if (thirst <= 0) {
      change -= _perSecond(_dehydratedHealthPerDay);
    }
    if (hunger > _wellFedLevel && thirst > _wellFedLevel) {
      change += _perSecond(_recoveryHealthPerDay);
    }
    return change;
  }

  void _tickCompost() {
    final wasReady = _compostRepository.pit.isReady;
    _compostRepository.tick();
    if (wasReady || !_compostRepository.pit.isReady) {
      return;
    }
    _constructionRepository.build(.compostPit);
    _feedbackRepository.show(
      const FeedbackMessage(
        text: 'Your compost is ready',
        mood: .happy,
      ),
    );
  }

  PlayerStats _endOfDayStats(PlayerStats stats) {
    final drop = _pollutionRepository.pollution.dailyHealthCeilingDrop;
    if (drop > 0) {
      _feedbackRepository.show(
        FeedbackMessage(
          text: 'The air is dirty max health −$drop',
          mood: .sad,
        ),
      );
      _react(.dirtyAir);
    }
    final ceiling = max(
      0.0,
      stats.healthCeiling - drop,
    );
    return stats.copyWith(
      health: min(
        stats.health,
        ceiling,
      ),
      healthCeiling: ceiling,
    );
  }

  void _react(HeroReaction reaction) {
    if (_heroReactionRepository.hear(reaction)) {
      _dialogueRepository.say(reaction.line);
    }
  }

  static double _perSecond(double perDay) => perDay / GameDay.secondsPerDay;
}
