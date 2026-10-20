import 'package:domain/pickup/model/pickup_kind.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/pickup/bloc/pickup_bloc.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class PickupPage extends StatefulWidget {
  const PickupPage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => PickupBloc()..add(const PickupStarted()),
    child: const PickupPage._(),
  );

  @override
  State<PickupPage> createState() => _PickupPageState();
}

class _PickupPageState extends State<PickupPage> {
  static const _itemSize = Size(120, 100);
  static const _plantSize = Size(150, 140);

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
              top: pickup.top,
              width: _size(pickup.kind).width,
              height: _size(pickup.kind).height,
              child: PressableContainer(
                image: _image(context, pickup.kind),
                onTap: () => _bloc.add(PickupTapped(pickup)),
              ),
            ),
        ],
      ),
    );
  }

  static Size _size(PickupKind kind) => switch (kind) {
    .cattail || .berryBush => _plantSize,
    .plastic || .cloth || .sand || .wood || .metal || .organics || .algae => _itemSize,
  };

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
