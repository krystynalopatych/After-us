import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/start/bloc/start_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class StartPage extends StatefulWidget {
  const StartPage._();

  static Widget withBloc({bool isLevelSelection = false}) => BlocProvider(
    create: (_) => StartBloc()..add(StartStarted(isLevelSelection: isLevelSelection)),
    child: const StartPage._(),
  );

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  static const _buttonTops = [330.0, 560.0, 790.0];
  static const _menuButtonWidth = 690.0;
  static const _buttonHeight = 230.0;
  static const _levelButtonWidth = 230.0;
  static const _backButtonOffset = 40.0;
  static const _backButtonWidth = 240.0;
  static const _backButtonHeight = 160.0;

  late final StartBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartBloc, StartState>(
      bloc: _bloc,
      builder: (context, state) => BackgroundContainer(
        image: context.images.imgLogoPage,
        elements: state.isLevelSelection ? _levelButtons(state) : _menuButtons(),
      ),
    );
  }

  List<BackgroundElement> _menuButtons() {
    final images = context.images;
    final buttons = [
      (images.imgButtonNewGame, () => _bloc.add(const StartNewGameTapped())),
      (images.imgButtonLoadGame, () => AppRoute.loadGame.go(context)),
      (images.imgButtonExit, () => _bloc.add(const StartExitTapped())),
    ];

    return [
      for (final (index, (image, onTap)) in buttons.indexed)
        _button(
          index,
          _menuButtonWidth,
          PressableContainer(
            image: image,
            onTap: onTap,
          ),
        ),
    ];
  }

  List<BackgroundElement> _levelButtons(StartState state) {
    final images = context.images;
    final buttons = [
      (images.imgButtonLevel1, GameLevel.level1),
      (images.imgButtonLevel2, GameLevel.level2),
      (images.imgButtonLevel3, GameLevel.level3),
    ];

    return [
      BackgroundElement(
        left: _backButtonOffset,
        top: _backButtonOffset,
        width: _backButtonWidth,
        height: _backButtonHeight,
        child: PressableContainer(
          image: images.imgButtonBack,
          onTap: () => _bloc.add(const StartBackTapped()),
        ),
      ),
      for (final (index, (image, level)) in buttons.indexed)
        _button(
          index,
          _levelButtonWidth,
          PressableContainer(
            image: image,
            isEnabled: level.index <= state.unlockedLevel.index,
            onTap: () => _onLevelTap(level),
          ),
        ),
    ];
  }

  void _onLevelTap(GameLevel level) {
    if (level == .level1) {
      AppRoute.fromLevel(level).go(context);
    }
  }

  BackgroundElement _button(
    int index,
    double width,
    Widget child,
  ) => BackgroundElement(
    left: (SceneContainer.designSize.width - width) / 2,
    top: _buttonTops[index],
    width: width,
    height: _buttonHeight,
    child: child,
  );
}
