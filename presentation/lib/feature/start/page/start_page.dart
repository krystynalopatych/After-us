import 'package:domain/app/repository/app_repository.dart';
import 'package:domain/character/repository/character_repository.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/start/bloc/start_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class StartPage extends StatelessWidget {
  static const _buttonTops = [330.0, 560.0, 790.0];
  static const _menuButtonWidth = 690.0;
  static const _buttonHeight = 230.0;
  static const _levelButtonWidth = 230.0;

  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => StartBloc(
        context.read<AppRepository>(),
        context.read<CharacterRepository>(),
        context.read<ProgressRepository>(),
      )..add(const StartStarted()),
      child: BlocBuilder<StartBloc, StartState>(
        builder: (context, state) => BackgroundContainer(
          image: context.images.imgLogoPage,
          elements: state.isLevelSelection ? _levelButtons(context, state) : _menuButtons(context),
        ),
      ),
    );
  }

  List<BackgroundElement> _menuButtons(BuildContext context) {
    final images = context.images;
    final bloc = context.read<StartBloc>();
    final buttons = [
      (images.imgButtonNewGame, () => bloc.add(const StartNewGameTapped())),
      (images.imgButtonLoadGame, () => AppRoute.loadGame.go(context)),
      (images.imgButtonExit, () => bloc.add(const StartExitTapped())),
    ];

    return [
      for (final (index, (image, onTap)) in buttons.indexed)
        _button(index, _menuButtonWidth, PressableContainer(image: image, onTap: onTap)),
    ];
  }

  List<BackgroundElement> _levelButtons(BuildContext context, StartState state) {
    final images = context.images;
    final buttons = [
      (images.imgButtonLevel1, GameLevel.level1),
      (images.imgButtonLevel2, GameLevel.level2),
      (images.imgButtonLevel3, GameLevel.level3),
    ];

    return [
      for (final (index, (image, level)) in buttons.indexed)
        _button(
          index,
          _levelButtonWidth,
          PressableContainer(
            image: image,
            isEnabled: level.index <= state.unlockedLevel.index,
            onTap: () => AppRoute.fromLevel(level).go(context),
          ),
        ),
    ];
  }

  BackgroundElement _button(int index, double width, Widget child) => BackgroundElement(
    left: (SceneContainer.designSize.width - width) / 2,
    top: _buttonTops[index],
    width: width,
    height: _buttonHeight,
    child: child,
  );
}
