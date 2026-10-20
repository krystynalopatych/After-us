import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_router.dart';

class AppPage extends StatefulWidget {
  final AppBloc Function() createAppBloc;
  final AppRepository appRepository;
  final CharacterRepository characterRepository;
  final ProgressRepository progressRepository;
  final SaveRepository saveRepository;

  const AppPage({
    super.key,
    required this.createAppBloc,
    required this.appRepository,
    required this.characterRepository,
    required this.progressRepository,
    required this.saveRepository,
  });

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final GoRouter _router = AppRouter.create();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.appRepository),
        RepositoryProvider.value(value: widget.characterRepository),
        RepositoryProvider.value(value: widget.progressRepository),
        RepositoryProvider.value(value: widget.saveRepository),
      ],
      child: BlocProvider(
        create: (_) => widget.createAppBloc(),
        child: MaterialApp.router(
          title: 'After Us',
          routerConfig: _router,
          builder: (context, child) {
            final brightness = MediaQuery.platformBrightnessOf(context);
            return DesignSystemTheme(
              data: brightness == .dark ? .dark() : .light(),
              brightness: brightness,
              child: SceneContainer(
                children: [
                  child!,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
