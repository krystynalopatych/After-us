import 'package:domain/station/model/station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/station/bloc/station_bloc.dart';
import 'package:presentation/feature/station/model/station_config.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class StationPage extends StatefulWidget {
  final AssetGenImage background;
  final VoidCallback onLocationTap;
  final ValueChanged<Station> onStationTap;

  const StationPage._({
    required this.background,
    required this.onLocationTap,
    required this.onStationTap,
  });

  static Widget withBloc({
    required AssetGenImage background,
    required VoidCallback onLocationTap,
    required ValueChanged<Station> onStationTap,
  }) => BlocProvider(
    create: (_) => StationBloc()..add(const StationStarted()),
    child: StationPage._(
      background: background,
      onLocationTap: onLocationTap,
      onStationTap: onStationTap,
    ),
  );

  @override
  State<StationPage> createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  late final StationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationBloc, StationState>(
      bloc: _bloc,
      builder: (context, state) => GestureDetector(
        behavior: .opaque,
        onTap: widget.onLocationTap,
        child: BackgroundContainer(
          image: widget.background,
          elements: [
            for (final MapEntry(key: station, value: spot) in StationConfig.spots.entries)
              if (state.built.contains(station))
                BackgroundElement(
                  left: spot.left,
                  top: spot.top,
                  width: spot.width,
                  height: spot.height,
                  child: GestureDetector(
                    behavior: .opaque,
                    onTap: () => widget.onStationTap(station),
                    child: _image(
                      context,
                      station,
                    ).image(fit: .contain),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  static AssetGenImage _image(
    BuildContext context,
    Station station,
  ) {
    final images = context.images;
    return switch (station) {
      .campfire => images.imgCampfire,
      .workbench => images.imgCraft,
      .rocketStove => images.imgRocketFire,
    };
  }
}
