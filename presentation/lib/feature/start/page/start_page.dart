import 'package:domain/repositories/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/start/bloc/start_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class StartPage extends StatelessWidget {
  static const _buttonTop = 440.0;
  static const _buttonWidth = 350.0;
  static const _buttonHeight = 200.0;
  static const _buttonLefts = [360.0, 810.0, 1260.0];

  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = context.images;
    final levels = [
      (images.level1Button, AppRoute.level1),
      (images.level2Button, AppRoute.level2),
      (images.level3Button, AppRoute.level3),
    ];

    return BlocProvider(
      lazy: false,
      create: (context) => StartBloc(context.read<CharacterRepository>())..add(const StartStarted()),
      child: BackgroundContainer(
        image: images.background,
        elements: [
          for (final (index, (image, route)) in levels.indexed)
            BackgroundElement(
              left: _buttonLefts[index],
              top: _buttonTop,
              width: _buttonWidth,
              height: _buttonHeight,
              child: PressableContainer(
                image: image,
                onTap: () => route.go(context),
              ),
            ),
        ],
      ),
    );
  }
}
