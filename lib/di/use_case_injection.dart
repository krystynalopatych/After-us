import 'package:domain/day/use_case/pass_second_use_case.dart';
import 'package:domain/location/use_case/travel_use_case.dart';
import 'package:domain/pickup/use_case/keep_pickup_use_case.dart';
import 'package:domain/pickup/use_case/location_pickups_use_case.dart';
import 'package:domain/pickup/use_case/throw_pickup_use_case.dart';
import 'package:domain/progress/use_case/start_level_use_case.dart';
import 'package:domain/save/use_case/save_game_use_case.dart';
import 'package:presentation/di/di_container.dart';

void registerUseCases() {
  diContainer
    ..registerFactory(
      () => KeepPickupUseCase(
        inventoryRepository: diContainer.get(),
        materialRepository: diContainer.get(),
        pickupRepository: diContainer.get(),
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
