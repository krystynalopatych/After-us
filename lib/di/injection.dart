import 'package:data/app/repository/app_repository_impl.dart';
import 'package:data/character/repository/character_repository_impl.dart';
import 'package:data/location/repository/location_repository_impl.dart';
import 'package:data/material/repository/material_repository_impl.dart';
import 'package:data/player/repository/player_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:data/save/repository/save_repository_impl.dart';
import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/location/repository/location_repository.dart';
import 'package:domain/material/repository/material_repository.dart';
import 'package:domain/player/repository/player_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:presentation/di/di_container.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';

AppBloc createAppBloc() => AppBloc();

void registerDependencies() {
  diContainer
    ..registerSingleton<AppRepository>(AppRepositoryImpl())
    ..registerSingleton<CharacterRepository>(CharacterRepositoryImpl())
    ..registerSingleton<LocationRepository>(LocationRepositoryImpl())
    ..registerSingleton<MaterialRepository>(MaterialRepositoryImpl())
    ..registerSingleton<PlayerRepository>(PlayerRepositoryImpl())
    ..registerSingleton<ProgressRepository>(ProgressRepositoryImpl())
    ..registerSingleton<SaveRepository>(SaveRepositoryImpl());
}
