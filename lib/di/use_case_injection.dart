import 'package:domain/compost/use_case/use_compost_pit_use_case.dart';
import 'package:domain/book/use_case/read_book_use_case.dart';
import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/day/use_case/pause_time_use_case.dart';
import 'package:domain/dialogue/use_case/hero_awake_use_case.dart';
import 'package:domain/dialogue/use_case/level_intro_use_case.dart';
import 'package:domain/dialogue/use_case/read_note_use_case.dart';
import 'package:domain/fridge/use_case/fridge_cooling_use_case.dart';
import 'package:domain/fridge/use_case/fridge_slot_use_case.dart';
import 'package:domain/fridge/use_case/water_fridge_use_case.dart';
import 'package:domain/garden/use_case/use_garden_bed_use_case.dart';
import 'package:domain/inventory/use_case/fill_bottle_use_case.dart';
import 'package:domain/inventory/use_case/lake_water_request_use_case.dart';
import 'package:domain/inventory/use_case/spoil_food_use_case.dart';
import 'package:domain/inventory/use_case/water_bottles_use_case.dart';
import 'package:domain/location/use_case/travel_use_case.dart';
import 'package:domain/mushroom/use_case/soak_cardboard_use_case.dart';
import 'package:domain/mushroom/use_case/use_mushroom_farm_use_case.dart';
import 'package:domain/pickup/use_case/keep_pickup_use_case.dart';
import 'package:domain/pickup/use_case/location_pickups_use_case.dart';
import 'package:domain/pickup/use_case/throw_pickup_use_case.dart';
import 'package:domain/player/use_case/consume_use_case.dart';
import 'package:domain/player/use_case/eat_seeds_use_case.dart';
import 'package:domain/progress/use_case/complete_level_use_case.dart';
import 'package:domain/progress/use_case/level_result_use_case.dart';
import 'package:domain/progress/use_case/new_game_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:domain/sound/use_case/hero_voice_use_case.dart';
import 'package:domain/sound/use_case/mute_sound_use_case.dart';
import 'package:domain/sound/use_case/play_message_sound_use_case.dart';
import 'package:domain/sound/use_case/stop_music_use_case.dart';
import 'package:domain/station/use_case/build_station_use_case.dart';
import 'package:domain/station/use_case/campfire_fuel_use_case.dart';
import 'package:domain/station/use_case/campfire_recipe_use_case.dart';
import 'package:domain/station/use_case/cook_on_campfire_use_case.dart';
import 'package:domain/station/use_case/craft_use_case.dart';
import 'package:domain/station/use_case/place_station_use_case.dart';
import 'package:domain/station/use_case/return_station_items_use_case.dart';
import 'package:domain/station/use_case/station_choices_use_case.dart';
import 'package:domain/station/use_case/workbench_slot_use_case.dart';
import 'package:domain/sun_spot/use_case/use_sun_spot_use_case.dart';
import 'package:domain/time_speed/use_case/set_time_speed_use_case.dart';
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
        fireRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => CompleteLevelUseCase(
        carryOverRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        fridgeRepository: diContainer.get(),
        gardenBedRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        mushroomFarmRepository: diContainer.get(),
        progressRepository: diContainer.get(),
        stationRepository: diContainer.get(),
        sunSpotRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => ConsumeUseCase(
        dayRepository: diContainer.get(),
        dialogueRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        mealRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => CookOnCampfireUseCase(
        bookRepository: diContainer.get(),
        campfireRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        fireRepository: diContainer.get(),
        dialogueRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
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
        soundRepository: diContainer.get(),
        workbenchRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => EatSeedsUseCase(
        dialogueRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => FillBottleUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => FridgeCoolingUseCase(
        dayRepository: diContainer.get(),
        fridgeRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => FridgeSlotUseCase(
        feedbackRepository: diContainer.get(),
        fridgeRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => HeroAwakeUseCase(dayRepository: diContainer.get()),
    )
    ..registerFactory(
      () => HeroVoiceUseCase(soundRepository: diContainer.get()),
    )
    ..registerFactory(
      () => KeepPickupUseCase(
        dialogueRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pickupHintRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
        soundRepository: diContainer.get(),
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
      () => LevelIntroUseCase(
        dialogueRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
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
      () => MuteSoundUseCase(soundRepository: diContainer.get()),
    )
    ..registerFactory(
      () => NewGameUseCase(
        bookRepository: diContainer.get(),
        carryOverRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
        pickupHintRepository: diContainer.get(),
        progressRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => PassSecondUseCase(
        clockRepository: diContainer.get(),
        compostRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        dialogueRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        gardenBedRepository: diContainer.get(),
        mushroomFarmRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
        sunSpotRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => PauseTimeUseCase(clockRepository: diContainer.get()),
    )
    ..registerFactory(
      () => PlaceStationUseCase(
        feedbackRepository: diContainer.get(),
        gardenBedRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        mushroomFarmRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        stationRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => PlayMessageSoundUseCase(soundRepository: diContainer.get()),
    )
    ..registerFactory(
      () => ReadBookUseCase(bookRepository: diContainer.get()),
    )
    ..registerFactory(
      () => ReadNoteUseCase(
        dialogueRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => ReturnStationItemsUseCase(
        fireRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        workbenchRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => SaveGameUseCase(
        campfireRepository: diContainer.get(),
        compostRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        fridgeRepository: diContainer.get(),
        gardenBedRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        locationRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        mushroomFarmRepository: diContainer.get(),
        mealRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        saveRepository: diContainer.get(),
        stationRepository: diContainer.get(),
        sunSpotRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => SetTimeSpeedUseCase(
        dayRepository: diContainer.get(),
        timeSpeedRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => SoakCardboardUseCase(
        bookRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => SpoilFoodUseCase(
        clockRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        fridgeRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => StartLevelUseCase(
        campfireRepository: diContainer.get(),
        carryOverRepository: diContainer.get(),
        characterRepository: diContainer.get(),
        clockRepository: diContainer.get(),
        compostRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        fireRepository: diContainer.get(),
        fridgeRepository: diContainer.get(),
        gardenBedRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        locationRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        mushroomFarmRepository: diContainer.get(),
        mealRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
        playerRepository: diContainer.get(),
        pollutionRepository: diContainer.get(),
        saveRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
        stationRepository: diContainer.get(),
        sunSpotRepository: diContainer.get(),
        workbenchRepository: diContainer.get(),
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
      () => StopMusicUseCase(soundRepository: diContainer.get()),
    )
    ..registerFactory(
      () => ThrowPickupUseCase(
        dialogueRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        heroReactionRepository: diContainer.get(),
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
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => UseGardenBedUseCase(
        constructionRepository: diContainer.get(),
        dayRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        gardenBedRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => UseMushroomFarmUseCase(
        bookRepository: diContainer.get(),
        constructionRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        mushroomFarmRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => UseSunSpotUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
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
      () => WaterFridgeUseCase(
        dayRepository: diContainer.get(),
        feedbackRepository: diContainer.get(),
        fridgeRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        soundRepository: diContainer.get(),
      ),
    )
    ..registerFactory(
      () => WorkbenchSlotUseCase(
        feedbackRepository: diContainer.get(),
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        selectionRepository: diContainer.get(),
        workbenchRepository: diContainer.get(),
      ),
    );
}
