import 'package:domain/dialogue/model/hero_reaction.dart';
import 'package:domain/dialogue/repository/dialogue_repository.dart';
import 'package:domain/dialogue/repository/hero_reaction_repository.dart';
import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/location/model/game_location.dart';
import 'package:domain/material/model/game_material.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';

final class ThrowPickupUseCase {
  final DialogueRepository _dialogueRepository;
  final FeedbackRepository _feedbackRepository;
  final HeroReactionRepository _heroReactionRepository;
  final PickupRepository _pickupRepository;
  final PollutionRepository _pollutionRepository;

  const ThrowPickupUseCase({
    required this._dialogueRepository,
    required this._feedbackRepository,
    required this._heroReactionRepository,
    required this._pickupRepository,
    required this._pollutionRepository,
  });

  void call(
    Pickup pickup,
    GameLocation target,
  ) {
    if (pickup.kind.material case final material?) {
      switch (target) {
        case .lake when material.pollutesWater:
          _pollutionRepository.polluteWater();
          _react(
            .lakePolluted,
            'You threw ${material.name} into the lake\nThe water is now polluted',
          );
        case .forest when material.pollutesSoil:
          _pollutionRepository.polluteSoil();
        case .lake || .forest:
          break;
        case .dump || .house || .store || .garage:
          _pollutionRepository.addAirPoints(material.airPoints);
          _reactToTrash(
            material,
            target,
          );
      }
    }
    _pickupRepository.collect(pickup);
  }

  void _reactToTrash(
    GameMaterial material,
    GameLocation target,
  ) {
    if (material.airPoints == 0) {
      return;
    }
    _react(
      .trashDumped,
      'You threw ${material.name} ${_place(target)} Air quality −${material.airPoints}',
    );
  }

  void _react(
    HeroReaction reaction,
    String text,
  ) {
    if (!_heroReactionRepository.hear(reaction)) {
      return;
    }
    _feedbackRepository.show(
      FeedbackMessage(
        text: text,
        mood: .sad,
      ),
    );
    _dialogueRepository.say(reaction.line);
  }

  static String _place(GameLocation location) => switch (location) {
    .dump => 'at the dump',
    .house => 'by the house',
    .store => 'by the store',
    .garage => 'by the garages',
    .lake => 'into the lake',
    .forest => 'in the forest',
  };
}
