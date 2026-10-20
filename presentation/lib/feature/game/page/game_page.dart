import 'package:domain/location/model/game_location.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/character/page/character_page.dart';
import 'package:presentation/feature/game/bloc/game_bloc.dart';
import 'package:presentation/feature/hud/page/hud_page.dart';
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
  static const _mapIconWidth = 340.0;
  static const _mapIconHeight = 311.0;
  static const _houseSpot = Offset(240, 0);
  static const _lakeSpot = Offset(1450, 94);
  static const _forestSpot = Offset(200, 484);
  static const _farSpot = Offset(1330, 704);

  late final GameBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          BackgroundContainer(image: _locationBackground(state.location)),
          CharacterPage.withBloc(),
          HudPage.withBloc(onMapTap: () => _bloc.add(const GameMapTapped())),
          if (state.isMapOpen) _map(),
        ],
      ),
    );
  }

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
