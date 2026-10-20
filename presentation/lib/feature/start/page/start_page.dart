import 'package:domain/character/repository/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/start/bloc/start_bloc.dart';

class StartPage extends StatelessWidget {
  static const _buttonWidth = 690.0;
  static const _buttonHeight = 230.0;
  static const _buttonLeft = (1920.0 - _buttonWidth) / 2;
  static const _buttonTops = [330.0, 560.0, 790.0];

  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final images = context.images;
    final buttons = [
      images.imgButtonNewGame,
      images.imgButtonLoadGame,
      images.imgButtonExit,
    ];

    return BlocProvider(
      lazy: false,
      create: (context) => StartBloc(context.read<CharacterRepository>())..add(const StartStarted()),
      child: BackgroundContainer(
        image: images.imgLogoPage,
        elements: [
          for (final (index, image) in buttons.indexed)
            BackgroundElement(
              left: _buttonLeft,
              top: _buttonTops[index],
              width: _buttonWidth,
              height: _buttonHeight,
              child: PressableContainer(
                image: image,
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}
