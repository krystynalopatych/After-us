import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/location/use_case/travel_use_case.dart';
import 'package:domain/pickup/use_case/keep_pickup_use_case.dart';
import 'package:domain/pickup/use_case/location_pickups_use_case.dart';
import 'package:domain/pickup/use_case/throw_pickup_use_case.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:domain/progress/use_case/level_result_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/station/use_case/build_station_use_case.dart';
import 'package:domain/station/use_case/campfire_fuel_use_case.dart';
import 'package:domain/station/use_case/campfire_recipe_use_case.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:domain/station/use_case/station_choices_use_case.dart';
import 'package:presentation/di/di_container.dart';

void registerUseCases() {
  diContainer
    ..registerFactory(
      () => BuildStationUseCase(
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        stationRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => CampfireFuelUseCase(
        feedbackRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => CampfireRecipeUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => ConsumeUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => CookOnCampfireUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => FillBottleUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => KeepPickupUseCase(
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => LevelResultUseCase(
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => LocationPickupsUseCase(
        locationRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => PassSecondUseCase(
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => SaveGameUseCase(
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        locationRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        saveRepository: diContainer.get(),
        stationRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => StartLevelUseCase(
        characterRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        locationRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        saveRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        stationRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => StationChoicesUseCase(
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        stationRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => ThrowPickupUseCase(
        pickupRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => TravelUseCase(
        locationRepository: diContainer.get(),
        playerRepository: diContainer.get(),
      ),
    );
}
