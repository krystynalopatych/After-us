import 'package:domain/location/model/game_location.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/load_game/bloc/load_game_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class LoadGamePage extends StatefulWidget {
  const LoadGamePage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => LoadGameBloc()..add(const LoadGameStarted()),
    child: const LoadGamePage._(),
  );

  @override
  State<LoadGamePage> createState() => _LoadGamePageState();
}

class _LoadGamePageState extends State<LoadGamePage> {
  static const _listWidth = 1000.0;
  static const _listTop = 330.0;
  static const _listHeight = 690.0;
  static const _rowPadding = EdgeInsets.symmetric(vertical: 12);
  static const _backButtonOffset = 40.0;
  static const _backButtonWidth = 240.0;
  static const _backButtonHeight = 160.0;

  late final LoadGameBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadGameBloc, LoadGameState>(
      bloc: _bloc,
      builder: (context, state) => BackgroundContainer(
        image: context.images.imgLogoPage,
        elements: [
          BackgroundElement(
            left: _backButtonOffset,
            top: _backButtonOffset,
            width: _backButtonWidth,
            height: _backButtonHeight,
            child: PressableContainer(
              image: context.images.imgButtonBack,
              onTap: () => AppRoute.start.go(context),
            ),
          ),
          BackgroundElement(
            left: (SceneContainer.designSize.width - _listWidth) / 2,
            top: _listTop,
            width: _listWidth,
            height: _listHeight,
            child: ListView(
              children: [
                for (final save in state.saves) _saveRow(save),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveRow(GameSave save) {
    final (colors, typography) = context.colorsTypography;

    return TapBuilder(
      onTap: () {
        _bloc.add(LoadGameSaveTapped(save));
        AppRoute.fromLevel(save.level).go(context);
      },
      builder: (context, isPressed, isHovered) => Padding(
        padding: _rowPadding,
        child: Text(
          'Level ${save.level.index + 1} · ${_locationTitle(save.location)} · ${_formatDate(save.savedAt)}',
          textAlign: .center,
          style: typography.headline.copyWith(
            color: isPressed || isHovered ? colors.base.orange : colors.base.white,
          ),
        ),
      ),
    );
  }

  static String _locationTitle(GameLocation location) => switch (location) {
    .forest => 'Forest',
    .lake => 'Lake',
    .garage => 'Garage',
    .house => 'House',
    .store => 'Abandoned Store',
    .dump => 'Dump',
  };

  static String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}.${twoDigits(date.month)}.${date.year} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}
