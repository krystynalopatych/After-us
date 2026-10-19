import 'package:data/repositories/character_repository_impl.dart';
import 'package:domain/repositories/character_repository.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';

AppBloc createAppBloc() => AppBloc();

CharacterRepository createCharacterRepository() => CharacterRepositoryImpl();
