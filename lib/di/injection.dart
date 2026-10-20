import 'package:data/app/repository/app_repository_impl.dart';
import 'package:data/character/repository/character_repository_impl.dart';
import 'package:data/progress/repository/progress_repository_impl.dart';
import 'package:data/save/repository/save_repository_impl.dart';
import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';

AppBloc createAppBloc() => AppBloc();

AppRepository createAppRepository() => AppRepositoryImpl();

CharacterRepository createCharacterRepository() => CharacterRepositoryImpl();

ProgressRepository createProgressRepository() => ProgressRepositoryImpl();

SaveRepository createSaveRepository() => SaveRepositoryImpl();
