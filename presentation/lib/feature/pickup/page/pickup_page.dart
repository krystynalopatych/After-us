import 'package:domain/location/model/game_location.dart';
import 'package:domain/pickup/model/pickup.dart';
import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/item_title_extension.dart';
import 'package:presentation/feature/pickup/bloc/pickup_bloc.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class PickupPage extends StatefulWidget {
  final double locationTop;

  const PickupPage._({required this.locationTop});

  static Widget withBloc({required double locationTop}) => BlocProvider(
    create: (_) => PickupBloc()..add(const PickupStarted()),
    child: PickupPage._(locationTop: locationTop),
  );

  @override
  State<PickupPage> createState() => _PickupPageState();
}

class _PickupPageState extends State<PickupPage> {
  static const _itemSize = Size(120, 100);
  static const _plantSize = Size(150, 140);
  static const _shadeOpacity = 0.5;
  static const _messageRect = Rect.fromLTWH(100, 560, 1100, 660);
  static const _foundRect = Rect.fromLTWH(1300, 590, 520, 520);
  static const _twoActionSize = Size(320, 192);
  static const _threeActionSize = Size(250, 150);
  static const _okActionSize = Size(250, 150);
  static const _throwTargets = [GameLocation.lake, GameLocation.dump, GameLocation.forest];

  late final PickupBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickupBloc, PickupState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          for (final pickup in state.pickups)
            Positioned(
              left: pickup.left,
              top: widget.locationTop + pickup.top,
              width: _size(pickup.kind).width,
              height: _size(pickup.kind).height,
              child: PressableContainer(
                image: _image(context, pickup.kind),
                onTap: () => _bloc.add(PickupTapped(pickup)),
              ),
            ),
          if (state.found case final found?) ..._dialog(found, state.step),
        ],
      ),
    );
  }

  List<Widget> _dialog(Pickup found, PickupStep step) {
    final colors = context.colors;

    return [
      Positioned.fill(
        child: GestureDetector(
          behavior: .opaque,
          child: ColoredBox(color: colors.base.black.withValues(alpha: _shadeOpacity)),
        ),
      ),
      Positioned.fromRect(rect: _messageRect, child: _message(found, step)),
      Positioned.fromRect(rect: _foundRect, child: _foundImage(context, found.kind).image(fit: .contain)),
    ];
  }

  Widget _message(Pickup found, PickupStep step) => switch (step) {
    .choice => MessageContainer(
      lines: ['YOU FOUND ${found.kind.title.toUpperCase()}', 'WHAT ARE YOU GONNA DO?'],
      actionSize: _twoActionSize,
      actions: [
        AnswerButtonContainer(text: 'THROW AWAY', onTap: () => _bloc.add(const PickupThrowTapped())),
        AnswerButtonContainer(text: 'KEEP IT', onTap: () => _bloc.add(const PickupKeepTapped())),
      ],
    ),
    .throwTarget => MessageContainer(
      lines: const ['WHERE TO THROW IT?'],
      actionSize: _threeActionSize,
      actions: [
        for (final target in _throwTargets)
          AnswerButtonContainer(
            text: _targetTitle(target),
            onTap: () => _bloc.add(PickupThrowTargetTapped(target)),
          ),
      ],
    ),
    .inventoryFull => MessageContainer(
      lines: const ['YOUR INVENTORY IS FULL'],
      actionSize: _okActionSize,
      actions: [
        AnswerButtonContainer(text: 'OK', onTap: () => _bloc.add(const PickupDismissed())),
      ],
    ),
  };

  static String _targetTitle(GameLocation target) => switch (target) {
    .lake => 'LAKE',
    .dump => 'DUMP',
    .forest => 'FOREST',
    .house || .store || .garage => '',
  };

  static Size _size(PickupKind kind) => switch (kind) {
    .cattail || .berryBush => _plantSize,
    .plastic || .cloth || .sand || .wood || .metal || .organics || .algae => _itemSize,
  };

  static AssetGenImage _foundImage(BuildContext context, PickupKind kind) {
    final images = context.images;
    return switch (kind) {
      .cattail => images.imgKoreniKamyshaSyrye,
      .berryBush => images.imgBerries,
      .plastic || .cloth || .sand || .wood || .metal || .organics || .algae => _image(context, kind),
    };
  }

  static AssetGenImage _image(BuildContext context, PickupKind kind) {
    final images = context.images;
    return switch (kind) {
      .plastic => images.imgPlasticBottle,
      .cloth => images.imgFabric,
      .sand => images.imgSand,
      .wood => images.imgWood,
      .metal => images.imgMetal,
      .organics => images.imgOrganic,
      .cattail => images.imgKamysh,
      .algae => images.imgSeaweedNEVymochenye,
      .berryBush => images.imgBushBerriespng,
    };
  }
}
