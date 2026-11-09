import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/fridge/model/fridge.dart';
import 'package:domain/fridge/repository/fridge_repository.dart';
import 'package:domain/garden/repository/garden_bed_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/mushroom/repository/mushroom_farm_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/model/level_carry_over.dart';
import 'package:domain/progress/repository/carry_over_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/station/repository/station_repository.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';

final class CompleteLevelUseCase {
  final CarryOverRepository _carryOverRepository;
  final ConstructionRepository _constructionRepository;
  final FridgeRepository _fridgeRepository;
  final GardenBedRepository _gardenBedRepository;
  final InventoryRepository _inventoryRepository;
  final MushroomFarmRepository _mushroomFarmRepository;
  final ProgressRepository _progressRepository;
  final StationRepository _stationRepository;
  final SunSpotRepository _sunSpotRepository;

  const CompleteLevelUseCase({
    required this._carryOverRepository,
    required this._constructionRepository,
    required this._fridgeRepository,
    required this._gardenBedRepository,
    required this._inventoryRepository,
    required this._mushroomFarmRepository,
    required this._progressRepository,
    required this._stationRepository,
    required this._sunSpotRepository,
  });

  void call(GameLevel level) {
    _progressRepository.completeLevel(level);
    final nextLevel = level.next;
    if (nextLevel == null) {
      return;
    }
    _returnSunBottle();
    _carryOverRepository.keep(
      nextLevel,
      LevelCarryOver(
        inventory: _inventoryRepository.stacks,
        constructions: _constructionRepository.built,
        stations: _stationRepository.built,
        fridge: Fridge(slots: _fridgeRepository.fridge.slots),
        gardenBed: _gardenBedRepository.bed.copyWith(seconds: 0),
        mushroomFarm: _mushroomFarmRepository.farm.copyWith(seconds: 0),
      ),
    );
  }

  void _returnSunBottle() {
    if (_sunSpotRepository.bottle == null) {
      return;
    }
    _sunSpotRepository.take();
    _inventoryRepository.add(.sodisBottle);
  }
}
