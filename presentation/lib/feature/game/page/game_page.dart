import 'dart:async';

import 'package:domain/location/model/game_location.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/location_image_extension.dart';
import 'package:presentation/feature/book/page/book_page.dart';
import 'package:presentation/feature/character/page/character_page.dart';
import 'package:presentation/feature/compost/page/compost_page.dart';
import 'package:presentation/feature/day/page/day_page.dart';
import 'package:presentation/feature/dialogue/page/dialogue_page.dart';
import 'package:presentation/feature/feedback/page/feedback_page.dart';
import 'package:presentation/feature/game/bloc/game_bloc.dart';
import 'package:presentation/feature/game_over/page/game_over_page.dart';
import 'package:presentation/feature/goal/page/goal_page.dart';
import 'package:presentation/feature/hud/page/hud_page.dart';
import 'package:presentation/feature/lake/page/lake_page.dart';
import 'package:presentation/feature/menu/page/menu_page.dart';
import 'package:presentation/feature/night/page/night_page.dart';
import 'package:presentation/feature/pickup/page/pickup_page.dart';
import 'package:presentation/feature/sky/page/sky_page.dart';
import 'package:presentation/feature/sun_spot/page/sun_spot_page.dart';
import 'package:presentation/feature/station/page/campfire_page.dart';
import 'package:presentation/feature/station/page/station_build_page.dart';
import 'package:presentation/feature/station/page/station_page.dart';
import 'package:presentation/feature/station/page/workbench_page.dart';
import 'package:presentation/feature/water/page/water_choice_page.dart';

class GamePage extends StatefulWidget {
  final GameLevel level;
  final VoidCallback onRetry;

  const GamePage._({
    required this.level,
    required this.onRetry,
  });

  static Widget withBloc({
    required GameLevel level,
    required VoidCallback onRetry,
  }) => BlocProvider(
    create: (_) => GameBloc()..add(const GameStarted()),
    child: GamePage._(
      level: level,
      onRetry: onRetry,
    ),
  );

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const _skyHeight = 450.0;
  static const _locationHeight = 1280.0;
  static const _horizonDepth = 160.0;
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
  static const _maxTravelWait = Duration(seconds: 3);

  late final GameBloc _bloc;
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

  Future<void> _closeMapWhenLoaded() async {
    await _sceneImagesLoaded().timeout(
      _maxTravelWait,
      onTimeout: () {},
    );
    if (!mounted || !_bloc.state.isTraveling) {
      return;
    }
    _bloc.add(const GameMapClosed());
  }

  Future<void> _sceneImagesLoaded() async {
    final binding = WidgetsBinding.instance;
    final imageCache = PaintingBinding.instance.imageCache;
    do {
      await binding.endOfFrame;
    } while (mounted && _bloc.state.isTraveling && imageCache.pendingImageCount > 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      bloc: _bloc,
      listenWhen: (previous, current) => !previous.isTraveling && current.isTraveling,
      listener: (context, state) => _closeMapWhenLoaded(),
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          SceneContainer(
            size: _sceneSize,
            children: [
              if (state.location.hasSky)
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  height: _skyHeight + _horizonDepth,
                  child: SkyPage.withBloc(hasSun: state.location == .lake),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: state.location.hasSky ? _locationHeight : _sceneSize.height,
                child: switch (state.location) {
                  .house => StationPage.withBloc(
                    background: state.location.background(context),
                    onLocationTap: () => _bloc.add(const GameLocationTapped()),
                    onStationTap: (station) => _bloc.add(GameStationTapped(station)),
                  ),
                  .lake => LakePage.withBloc(onWaterTap: () => _bloc.add(const GameLakeWaterTapped())),
                  .forest || .dump || .store || .garage => BackgroundContainer(
                    image: state.location.background(context),
                  ),
                },
              ),
              if (state.location == .house) Positioned.fill(child: CompostPage.withBloc(locationTop: _skyHeight)),
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
              if (state.location == .lake) Positioned.fill(child: SunSpotPage.withBloc(locationTop: _skyHeight)),
              if (state.isStationOpen) _pickups(),
              if (state.fireStation case final station?)
                Positioned.fill(
                  child: CampfirePage.withBloc(
                    station: station,
                    onClose: () => _bloc.add(const GameFireClosed()),
                  ),
                ),
              if (state.isWorkbenchOpen)
                Positioned.fill(
                  child: WorkbenchPage.withBloc(
                    onClose: () => _bloc.add(const GameWorkbenchClosed()),
                    onBookTap: () => _bloc.add(const GameBookTapped()),
                  ),
                ),
              Positioned.fill(
                child: HudPage.withBloc(
                  onMapTap: () => _bloc.add(const GameMapTapped()),
                  characterTaps: _characterTaps.stream,
                ),
              ),
              if (!state.isStationOpen) _pickups(),
              if (state.waterChoice case final water?)
                Positioned.fill(
                  child: WaterChoicePage.withBloc(
                    water: water,
                    onClose: () => _bloc.add(const GameWaterChoiceClosed()),
                  ),
                ),
              if (state.isBuildOpen)
                Positioned.fill(child: StationBuildPage.withBloc(onClose: () => _bloc.add(const GameBuildClosed()))),
              if (state.isBookOpen)
                Positioned.fill(child: BookPage.withBloc(onClose: () => _bloc.add(const GameBookClosed()))),
              Positioned.fill(child: MenuPage.withBloc(level: widget.level)),
              Positioned.fill(child: DayPage.withBloc(level: widget.level)),
              Positioned.fill(child: GoalPage.withBloc(level: widget.level)),
              Positioned.fill(child: NightPage.withBloc()),
              Positioned.fill(child: DialoguePage.withBloc()),
              Positioned.fill(child: FeedbackPage.withBloc()),
            ],
          ),
          if (state.isMapOpen) _map(),
          GameOverPage.withBloc(
            level: widget.level,
            onRetry: widget.onRetry,
          ),
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
              image: location.icon(context),
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
}
