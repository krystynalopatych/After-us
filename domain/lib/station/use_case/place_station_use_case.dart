import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/garden/repository/garden_bed_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/mushroom/model/mushroom_farm.dart';
import 'package:domain/mushroom/repository/mushroom_farm_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/model/station.dart';
import 'package:domain/station/repository/station_repository.dart';

final class PlaceStationUseCase {
  final FeedbackRepository _feedbackRepository;
  final GardenBedRepository _gardenBedRepository;
  final MaterialRepository _materialRepository;
  final MushroomFarmRepository _mushroomFarmRepository;
  final InventoryRepository _inventoryRepository;
  final SelectionRepository _selectionRepository;
  final StationRepository _stationRepository;

  const PlaceStationUseCase({
    required this._feedbackRepository,
    required this._gardenBedRepository,
    required this._materialRepository,
    required this._mushroomFarmRepository,
    required this._inventoryRepository,
    required this._selectionRepository,
    required this._stationRepository,
  });

  bool call() {
    if (_selectionRepository.selection.material == .wetCardboard) {
      return _placeMushroomFarm();
    }
    final item = switch (_selectionRepository.selection.slot) {
      final slot? => _inventoryRepository.stacks.elementAtOrNull(slot)?.item,
      null => null,
    };
    if (item == .gardenBed) {
      return _placeGardenBed();
    }
    final station = switch (item) {
      .rocketStove => Station.rocketStove,
      .clayFridge => Station.clayFridge,
      _ => null,
    };
    if (item == null ||
        station == null ||
        _stationRepository.built.contains(station) ||
        !_inventoryRepository.remove(item)) {
      return false;
    }
    _stationRepository.build(station);
    _selectionRepository.reset();
    _feedbackRepository.show(
      FeedbackMessage(
        text: switch (station) {
          .clayFridge => 'You set up the clay fridge Water it with lake water every day',
          .campfire || .workbench || .rocketStove => 'You set up the rocket stove',
        },
        mood: .happy,
      ),
    );
    return true;
  }

  bool _placeGardenBed() {
    if (_gardenBedRepository.bed.isPlaced || !_inventoryRepository.remove(.gardenBed)) {
      return false;
    }
    _gardenBedRepository.place();
    _selectionRepository.reset();
    _feedbackRepository.show(
      const FeedbackMessage(
        text: 'You set up the garden bed Plant 2 seeds in it',
        mood: .happy,
      ),
    );
    return true;
  }

  bool _placeMushroomFarm() {
    if (_mushroomFarmRepository.farm.isPlaced) {
      return false;
    }
    if (!_materialRepository.remove(
      .wetCardboard,
      MushroomFarm.cardboardNeeded,
    )) {
      _feedbackRepository.show(
        const FeedbackMessage(text: 'You need ${MushroomFarm.cardboardNeeded} wet cardboard for a mushroom farm'),
      );
      return true;
    }
    _mushroomFarmRepository.place();
    _selectionRepository.reset();
    _feedbackRepository.show(
      const FeedbackMessage(
        text: 'You laid the wet cardboard Plant a wild mushroom on it',
        mood: .happy,
      ),
    );
    return true;
  }
}
