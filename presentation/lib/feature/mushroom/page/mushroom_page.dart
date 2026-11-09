import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/mushroom/bloc/mushroom_bloc.dart';

class MushroomPage extends StatefulWidget {
  final double locationTop;

  const MushroomPage._({required this.locationTop});

  static Widget withBloc({required double locationTop}) => BlocProvider(
    create: (_) => MushroomBloc()..add(const MushroomStarted()),
    child: MushroomPage._(locationTop: locationTop),
  );

  @override
  State<MushroomPage> createState() => _MushroomPageState();
}

class _MushroomPageState extends State<MushroomPage> {
  static const _farmRect = Rect.fromLTWH(
    760,
    540,
    260,
    180,
  );
  static const _plantedRect = Rect.fromLTWH(
    690,
    490,
    400,
    280,
  );
  static const _timerRect = Rect.fromLTWH(
    1000,
    500,
    110,
    110,
  );

  late final MushroomBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final images = context.images;

    return BlocBuilder<MushroomBloc, MushroomState>(
      bloc: _bloc,
      builder: (context, state) {
        final farm = state.farm;
        if (!farm.isPlaced) {
          return const SizedBox.shrink();
        }
        return Stack(
          fit: .expand,
          children: [
            Positioned.fromRect(
              rect: _onScene(farm.isPlanted ? _plantedRect : _farmRect),
              child: (farm.isPlanted ? images.imgMushroomsFarm : images.imgWetCardboard).image(fit: .contain),
            ),
            if (farm.isPlanted)
              Positioned.fromRect(
                rect: _onScene(_timerRect),
                child: TimerContainer(
                  progress: farm.progress,
                  isDone: farm.isReady,
                ),
              ),
            Positioned.fromRect(
              rect: _onScene(_farmRect),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: .opaque,
                  onTap: () => _bloc.add(const MushroomFarmTapped()),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Rect _onScene(Rect rect) => rect.translate(
    0,
    widget.locationTop,
  );
}
