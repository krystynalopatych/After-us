import 'package:domain/material/model/game_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/hud/bloc/hud_bloc.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class HudPage extends StatefulWidget {
  final VoidCallback onMapTap;

  const HudPage._({required this.onMapTap});

  static Widget withBloc({required VoidCallback onMapTap}) => BlocProvider(
    create: (_) => HudBloc()..add(const HudStarted()),
    child: HudPage._(onMapTap: onMapTap),
  );

  @override
  State<HudPage> createState() => _HudPageState();
}

class _HudPageState extends State<HudPage> {
  static const _materialOffset = 20.0;
  static const _materialSize = 140.0;
  static const _materialSpacing = 10.0;
  static const _statWidth = 150.0;
  static const _statHeight = 141.0;
  static const _statTop = 938.0;
  static const _healthLeft = 438.0;
  static const _hungerLeft = 572.0;
  static const _healthValueAlignment = Alignment(0.146, 0.068);
  static const _hungerValueAlignment = Alignment(0.199, 0.093);
  static const _thirstLeft = 505.0;
  static const _thirstTop = 822.0;
  static const _thirstValueAlignment = Alignment(0.203, 0.088);
  static const _inventoryLeft = 718.0;
  static const _inventoryTop = 872.0;
  static const _inventoryWidth = 820.0;
  static const _inventoryHeight = 273.0;
  static const _mapLeft = 1760.0;
  static const _mapTop = 910.0;
  static const _mapSize = 150.0;

  late final HudBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HudBloc, HudState>(
      bloc: _bloc,
      builder: (context, state) {
        final images = context.images;

        return Stack(
          fit: .expand,
          children: [
            for (final (index, stock) in state.stocks.indexed)
              Positioned(
                left: _materialOffset + index * (_materialSize + _materialSpacing),
                top: _materialOffset,
                width: _materialSize,
                height: _materialSize,
                child: MaterialContainer(
                  frame: images.imgResourseIcon,
                  image: _materialImage(context, stock.material),
                  count: stock.count,
                ),
              ),
            Positioned(
              left: _thirstLeft,
              top: _thirstTop,
              width: _statWidth,
              height: _statHeight,
              child: StatContainer(
                image: images.imgPlayerThirsty,
                value: state.stats.thirst,
                valueAlignment: _thirstValueAlignment,
              ),
            ),
            Positioned(
              left: _healthLeft,
              top: _statTop,
              width: _statWidth,
              height: _statHeight,
              child: StatContainer(
                image: images.imgPlayerHp,
                value: state.stats.health,
                valueAlignment: _healthValueAlignment,
              ),
            ),
            Positioned(
              left: _hungerLeft,
              top: _statTop,
              width: _statWidth,
              height: _statHeight,
              child: StatContainer(
                image: images.imgPlayerHunger,
                value: state.stats.hunger,
                valueAlignment: _hungerValueAlignment,
              ),
            ),
            Positioned(
              left: _inventoryLeft,
              top: _inventoryTop,
              width: _inventoryWidth,
              height: _inventoryHeight,
              child: images.imgInventory.image(fit: .contain),
            ),
            Positioned(
              left: _mapLeft,
              top: _mapTop,
              width: _mapSize,
              height: _mapSize,
              child: PressableContainer(
                image: images.imgMapIcon,
                onTap: widget.onMapTap,
              ),
            ),
          ],
        );
      },
    );
  }

  static AssetGenImage _materialImage(BuildContext context, GameMaterial material) {
    final images = context.images;
    return switch (material) {
      .plastic => images.imgPlasticBottle,
      .cloth => images.imgFabric,
      .sand => images.imgSand,
      .metal => images.imgMetal,
      .organics => images.imgOrganic,
      .cardboard => images.imgCardboard,
      .seeds => images.imgSeeds,
      .clay => images.imgClay,
      .oil => images.imgOil,
      .chlorine => images.imgChlorine,
    };
  }
}
