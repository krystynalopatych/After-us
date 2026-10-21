import 'dart:async';

import 'package:domain/location/model/game_location.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/character/page/character_page.dart';
import 'package:presentation/feature/day/page/day_page.dart';
import 'package:presentation/feature/feedback/page/feedback_page.dart';
import 'package:presentation/feature/game/bloc/game_bloc.dart';
import 'package:presentation/feature/game_over/page/game_over_page.dart';
import 'package:presentation/feature/goal/page/goal_page.dart';
import 'package:presentation/feature/hud/page/hud_page.dart';
import 'package:presentation/feature/menu/page/menu_page.dart';
import 'package:presentation/feature/pickup/page/pickup_page.dart';
import 'package:presentation/feature/sky/page/sky_page.dart';
import 'package:presentation/feature/station/page/campfire_page.dart';
import 'package:presentation/feature/station/page/station_build_page.dart';
import 'package:presentation/feature/station/page/station_page.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class GamePage extends StatefulWidget {
  final GameLevel level;

  const GamePage._({required this.level});

  static Widget withBloc({required GameLevel level}) => BlocProvider(
    create: (_) => GameBloc()..add(const GameStarted()),
    child: GamePage._(level: level),
  );

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const _skyHeight = 450.0;
  static const _locationHeight = 1280.0;
  static const _sceneSize = Size(
    1920,
    _skyHeight + _locationHeight,
  );
  static const _sunLightRect = Rect.fromLTWH(
    583,
    _skyHeight,
    680,
    1020,
  );
  static const _lakeWaterRect = Rect.fromLTWH(
    560,
    _skyHeight + 340,
    760,
    380,
  );
  static const _closeButtonOffset = 40.0;
  static const _closeButtonSize = 150.0;
  static const _mapIconWidth = 340.0;
  static const _mapIconHeight = 311.0;
  static const _houseSpot = Offset(
    240,
    0,
  );
  static const _lakeSpot = Offset(
    1450,
    94,
  );
  static const _forestSpot = Offset(
    200,
    484,
  );
  static const _farSpot = Offset(
    1330,
    704,
  );

  late final GameBloc _bloc;
  var _isPrecached = false;
  final _characterTaps = StreamController<void>.broadcast();

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  void dispose() {
    _characterTaps.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isPrecached) {
      return;
    }
    _isPrecached = true;
    for (final image in [
      context.images.imgMap,
      context.images.imgButtonClose,
      context.images.imgSunLight,
      for (final location in widget.level.locations) ...[
        _locationBackground(location),
        _locationIcon(location),
      ],
    ]) {
      precacheImage(
        image.provider(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          SceneContainer(
            size: _sceneSize,
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: _skyHeight,
                child: SkyPage.withBloc(hasSun: state.location == .lake),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _locationHeight,
                child: state.location == .house
                    ? StationPage.withBloc(
                        background: _locationBackground(state.location),
                        onLocationTap: () => _bloc.add(const GameLocationTapped()),
                        onStationTap: (station) => _bloc.add(GameStationTapped(station)),
                      )
                    : BackgroundContainer(image: _locationBackground(state.location)),
              ),
              if (state.location == .lake)
                Positioned.fromRect(
                  rect: _sunLightRect,
                  child: context.images.imgSunLight.image(fit: .contain),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: SceneContainer.designSize.height,
                child: CharacterPage.withBloc(onTap: () => _characterTaps.add(null)),
              ),
              if (state.location == .lake)
                Positioned.fromRect(
                  rect: _lakeWaterRect,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: .opaque,
                      onTap: () => _bloc.add(const GameLakeWaterTapped()),
                    ),
                  ),
                ),
              if (state.isCampfireOpen) ...[
                _pickups(),
                Positioned.fill(child: CampfirePage.withBloc(onClose: () => _bloc.add(const GameCampfireClosed()))),
              ],
              Positioned.fill(
                child: HudPage.withBloc(
                  onMapTap: () => _bloc.add(const GameMapTapped()),
                  characterTaps: _characterTaps.stream,
                ),
              ),
              if (!state.isCampfireOpen) _pickups(),
              if (state.isBuildOpen)
                Positioned.fill(child: StationBuildPage.withBloc(onClose: () => _bloc.add(const GameBuildClosed()))),
              Positioned.fill(child: MenuPage.withBloc(level: widget.level)),
              Positioned.fill(child: DayPage.withBloc(level: widget.level)),
              Positioned.fill(child: GoalPage.withBloc(level: widget.level)),
              Positioned.fill(child: FeedbackPage.withBloc()),
            ],
          ),
          if (state.isMapOpen) _map(),
          GameOverPage.withBloc(level: widget.level),
        ],
      ),
    );
  }

  Widget _pickups() => Positioned.fill(
    child: PickupPage.withBloc(
      level: widget.level,
      locationTop: _skyHeight,
    ),
  );

  Widget _map() {
    return BackgroundContainer(
      image: context.images.imgMap,
      elements: [
        for (final location in widget.level.locations)
          BackgroundElement(
            left: _mapSpot(location).dx,
            top: _mapSpot(location).dy,
            width: _mapIconWidth,
            height: _mapIconHeight,
            child: PressableContainer(
              image: _locationIcon(location),
              onTap: () => _bloc.add(GameLocationSelected(location)),
            ),
          ),
        BackgroundElement(
          left: _closeButtonOffset,
          top: _closeButtonOffset,
          width: _closeButtonSize,
          height: _closeButtonSize,
          child: PressableContainer(
            image: context.images.imgButtonClose,
            onTap: () => _bloc.add(const GameMapClosed()),
          ),
        ),
      ],
    );
  }

  static Offset _mapSpot(GameLocation location) => switch (location) {
    .house => _houseSpot,
    .lake => _lakeSpot,
    .forest => _forestSpot,
    .dump || .store || .garage => _farSpot,
  };

  AssetGenImage _locationBackground(GameLocation location) {
    final images = context.images;
    return switch (location) {
      .house => images.imgHouseRectangle,
      .forest => images.imgForestRectangle,
      .lake => images.imgLakeRectangle,
      .dump => images.imgSvalka,
      .store => images.imgAbandonnedStore,
      .garage => images.imgGarage,
    };
  }

  AssetGenImage _locationIcon(GameLocation location) {
    final images = context.images;
    return switch (location) {
      .house => images.imgHomeIcon,
      .forest => images.imgForestIcon,
      .lake => images.imgLakeIcon,
      .dump => images.imgSvalkaIcon,
      .store => images.imgStoreIcon,
      .garage => images.imgGarageIcon,
    };
  }
}
