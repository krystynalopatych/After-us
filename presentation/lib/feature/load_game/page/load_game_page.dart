import 'package:domain/save/model/game_location.dart';
import 'package:domain/save/model/game_save.dart';
import 'package:domain/save/repository/save_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/load_game/bloc/load_game_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class LoadGamePage extends StatelessWidget {
  static const _listWidth = 1000.0;
  static const _listTop = 330.0;
  static const _listHeight = 690.0;
  static const _rowPadding = EdgeInsets.symmetric(vertical: 12);

  const LoadGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => LoadGameBloc(context.read<SaveRepository>())..add(const LoadGameStarted()),
      child: BlocBuilder<LoadGameBloc, LoadGameState>(
        builder: (context, state) => BackgroundContainer(
          image: context.images.imgLogoPage,
          elements: [
            BackgroundElement(
              left: (SceneContainer.designSize.width - _listWidth) / 2,
              top: _listTop,
              width: _listWidth,
              height: _listHeight,
              child: ListView(
                children: [
                  for (final save in state.saves) _saveRow(context, save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveRow(BuildContext context, GameSave save) {
    final (colors, typography) = context.colorsTypography;

    return TapBuilder(
      onTap: () => AppRoute.fromLevel(save.level).go(context),
      builder: (context, isPressed, isHovered) => Padding(
        padding: _rowPadding,
        child: Text(
          'Level ${save.level.index + 1} · ${_locationTitle(save.location)} · ${_formatDate(save.savedAt)}',
          textAlign: .center,
          style: typography.title.copyWith(
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
