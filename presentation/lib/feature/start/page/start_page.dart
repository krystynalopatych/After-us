import 'package:domain/character/repository/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/start/bloc/start_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class StartPage extends StatelessWidget {
  static const _buttonTop = 220.0;
  static const _buttonSize = 300.0;
  static const _buttonLefts = [410.0, 810.0, 1210.0];

  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = context.images;
    final levels = [
      (images.imgButtonLevel1, AppRoute.level1),
      (images.imgButtonLevel2, AppRoute.level2),
      (images.imgButtonLevel3, AppRoute.level3),
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
              width: _buttonSize,
              height: _buttonSize,
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
