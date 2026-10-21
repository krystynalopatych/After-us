import 'package:after_us_game/di/use_case_injection.dart';
import 'package:data/app/repository/app_repository_impl.dart';
import 'package:data/character/repository/character_repository_impl.dart';
import 'package:data/compost/repository/compost_repository_impl.dart';
import 'package:data/construction/repository/construction_repository_impl.dart';
import 'package:data/day/repository/day_repository_impl.dart';
import 'package:data/day/repository/ticker_repository_impl.dart';
import 'package:data/feedback/repository/feedback_repository_impl.dart';
import 'package:data/inventory/repository/inventory_repository_impl.dart';
import 'package:data/location/repository/location_repository_impl.dart';
import 'package:data/material/repository/material_repository_impl.dart';
import 'package:data/pickup/repository/pickup_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/pollution/repository/pollution_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:data/save/repository/save_repository_impl.dart';
import 'package:data/selection/repository/selection_repository_impl.dart';
import 'package:data/station/repository/campfire_repository_impl.dart';
import 'package:data/station/repository/station_repository_impl.dart';
import 'package:data/sun_spot/repository/sun_spot_repository_impl.dart';
import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/compost/repository/compost_repository.dart';
import 'package:domain/construction/repository/construction_repository.dart';
import 'package:domain/day/repository/day_repository.dart';
import 'package:domain/day/repository/ticker_repository.dart';
import 'package:domain/feedback/repository/feedback_repository.dart';
import 'package:domain/inventory/repository/inventory_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/pickup/repository/pickup_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/pollution/repository/pollution_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:domain/selection/repository/selection_repository.dart';
import 'package:domain/station/repository/campfire_repository.dart';
import 'package:domain/station/repository/station_repository.dart';
import 'package:domain/sun_spot/repository/sun_spot_repository.dart';
import 'package:presentation/di/di_container.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';

AppBloc createAppBloc() => AppBloc();

void registerDependencies() {
  diContainer
    ..registerSingleton<AppRepository>(AppRepositoryImpl())
    ..registerSingleton<CampfireRepository>(CampfireRepositoryImpl())
    ..registerSingleton<CharacterRepository>(CharacterRepositoryImpl())
    ..registerSingleton<CompostRepository>(CompostRepositoryImpl())
    ..registerSingleton<ConstructionRepository>(ConstructionRepositoryImpl())
    ..registerSingleton<DayRepository>(DayRepositoryImpl())
    ..registerSingleton<FeedbackRepository>(FeedbackRepositoryImpl())
    ..registerSingleton<InventoryRepository>(InventoryRepositoryImpl())
    ..registerSingleton<LocationRepository>(LocationRepositoryImpl())
    ..registerSingleton<MaterialRepository>(MaterialRepositoryImpl())
    ..registerSingleton<PickupRepository>(PickupRepositoryImpl())
    ..registerSingleton<PlayerRepository>(PlayerRepositoryImpl())
    ..registerSingleton<PollutionRepository>(PollutionRepositoryImpl())
    ..registerSingleton<ProgressRepository>(ProgressRepositoryImpl())
    ..registerSingleton<SaveRepository>(SaveRepositoryImpl())
    ..registerSingleton<SelectionRepository>(SelectionRepositoryImpl())
    ..registerSingleton<StationRepository>(StationRepositoryImpl())
    ..registerSingleton<SunSpotRepository>(SunSpotRepositoryImpl())
    ..registerSingleton<TickerRepository>(TickerRepositoryImpl());
  registerUseCases();
}
