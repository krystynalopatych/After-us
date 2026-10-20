import 'package:domain/character/repository/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_router.dart';

class AppPage extends StatefulWidget {
  final AppBloc Function() createAppBloc;
  final CharacterRepository characterRepository;

  const AppPage({
    super.key,
    required this.createAppBloc,
    required this.characterRepository,
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
    return RepositoryProvider.value(
      value: widget.characterRepository,
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
