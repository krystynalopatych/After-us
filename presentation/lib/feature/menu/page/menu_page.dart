import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/menu/bloc/menu_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class MenuPage extends StatefulWidget {
  final GameLevel level;

  const MenuPage._({required this.level});

  static Widget withBloc({required GameLevel level}) => BlocProvider(
    create: (_) => MenuBloc()..add(const MenuStarted()),
    child: MenuPage._(level: level),
  );

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const _buttonOffset = 20.0;
  static const _buttonSize = 150.0;
  static const _panelWidth = 220.0;
  static const _buttonInset = (_panelWidth - _buttonSize) / 2;
  static const _saveTop = 200.0;
  static const _soundTop = 380.0;
  static const _exitTop = 560.0;
  static const _doneWidth = 110.0;
  static const _doneHeight = 86.0;
  static const _doneSpacing = 10.0;
  static const _doneDuration = Duration(milliseconds: 200);

  late final MenuBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      bloc: _bloc,
      builder: (context, state) {
        final images = context.images;

        return LayoutBuilder(
          builder: (context, constraints) => Stack(
            fit: .expand,
            children: [
              if (state.isOpen)
                GestureDetector(
                  behavior: .opaque,
                  onTap: () => _bloc.add(const MenuClosed()),
                ),
              SidePanelContainer(
                isOpen: state.isOpen,
                width: _panelWidth,
                child: Stack(
                  children: [
                    _panelButton(
                      top: _saveTop,
                      child: PressableContainer(
                        image: images.imgSaveIcon,
                        onTap: () => _bloc.add(MenuSaveTapped(widget.level)),
                      ),
                    ),
                    _panelButton(
                      top: _soundTop,
                      child: PressableContainer(
                        image: state.isMuted ? images.imgSoundIcon : images.imgSoundMutedIcon,
                        onTap: () => _bloc.add(const MenuSoundTapped()),
                      ),
                    ),
                    _panelButton(
                      top: _exitTop,
                      child: PressableContainer(
                        image: images.imgExitIcon,
                        onTap: () {
                          _bloc.add(const MenuExitTapped());
                          AppRoute.start.go(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: constraints.maxWidth - _panelWidth - _doneSpacing - _doneWidth,
                top: _saveTop + (_buttonSize - _doneHeight) / 2,
                width: _doneWidth,
                height: _doneHeight,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: state.isSaved ? 1 : 0,
                    duration: _doneDuration,
                    child: images.imgDoneIcon.image(fit: .contain),
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth - _panelWidth + _buttonInset,
                top: _buttonOffset,
                width: _buttonSize,
                height: _buttonSize,
                child: PressableContainer(
                  image: images.imgButtonMenu,
                  onTap: () => _bloc.add(const MenuToggled()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _panelButton({
    required double top,
    required Widget child,
  }) => Positioned(
    left: _buttonInset,
    top: top,
    width: _buttonSize,
    height: _buttonSize,
    child: child,
  );
}
