import 'package:domain/compost/use_case/use_compost_pit_use_case.dart';
import 'package:domain/book/use_case/read_book_use_case.dart';
import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/inventory/use_case/lake_water_request_use_case.dart';
import 'package:domain/inventory/use_case/water_bottles_use_case.dart';
import 'package:domain/location/use_case/travel_use_case.dart';
import 'package:domain/pickup/use_case/keep_pickup_use_case.dart';
import 'package:domain/pickup/use_case/location_pickups_use_case.dart';
import 'package:domain/pickup/use_case/throw_pickup_use_case.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:domain/progress/use_case/complete_level_use_case.dart';
import 'package:domain/progress/use_case/level_result_use_case.dart';
import 'package:domain/progress/use_case/new_game_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/station/use_case/build_station_use_case.dart';
import 'package:domain/station/use_case/campfire_fuel_use_case.dart';
import 'package:domain/station/use_case/campfire_recipe_use_case.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/place_station_use_case.dart';
import 'package:domain/station/use_case/station_choices_use_case.dart';
import 'package:domain/station/use_case/workbench_slot_use_case.dart';
import 'package:domain/sun_spot/use_case/use_sun_spot_use_case.dart';
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
      () => CompleteLevelUseCase(progressRepository: diContainer.get()),
    )
    ..registerFactory(
      () => ConsumeUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => CookOnCampfireUseCase(
        campfireRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => CraftUseCase(
        bookRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => FillBottleUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
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
      () => LakeWaterRequestUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
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
      () => NewGameUseCase(
        bookRepository: diContainer.get(),
        progressRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => PassSecondUseCase(
        compostRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        sunSpotRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => PlaceStationUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        stationRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => ReadBookUseCase(bookRepository: diContainer.get()),
    )
    ..registerFactory(
      () => SaveGameUseCase(
        campfireRepository: diContainer.get(),
        compostRepository: diContainer.get(),
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
        sunSpotRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => StartLevelUseCase(
        campfireRepository: diContainer.get(),
        compostRepository: diContainer.get(),
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
        sunSpotRepository: diContainer.get(),
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
    )
    ..registerFactory(
      () => UseCompostPitUseCase(
        compostRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => UseSunSpotUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        sunSpotRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => WaterBottlesUseCase(
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => WorkbenchSlotUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    );
}
