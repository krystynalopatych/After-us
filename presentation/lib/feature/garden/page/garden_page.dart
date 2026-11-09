import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/garden/bloc/garden_bloc.dart';

class GardenPage extends StatefulWidget {
  final double locationTop;

  const GardenPage._({required this.locationTop});

  static Widget withBloc({required double locationTop}) => BlocProvider(
    create: (_) => GardenBloc()..add(const GardenStarted()),
    child: GardenPage._(locationTop: locationTop),
  );

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  static const _bedRect = Rect.fromLTWH(
    620,
    330,
    280,
    190,
  );
  static const _greenhouseRect = Rect.fromLTWH(
    567,
    262,
    386,
    258,
  );
  static const _potatoesRect = Rect.fromLTWH(
    634,
    326,
    252,
    168,
  );
  static const _timerRect = Rect.fromLTWH(
    910,
    330,
    110,
    110,
  );

  late final GardenBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final images = context.images;

    return BlocBuilder<GardenBloc, GardenState>(
      bloc: _bloc,
      builder: (context, state) {
        final bed = state.bed;
        if (!bed.isPlaced) {
          return const SizedBox.shrink();
        }
        return Stack(
          fit: .expand,
          children: [
            if (bed.hasGreenhouse && !bed.isReady)
              Positioned.fromRect(
                rect: _onScene(_greenhouseRect),
                child: (bed.hasSprouts ? images.imgGryadkaWithGreenhouseRastet : images.imgGryadkaWithGreenhouse).image(
                  fit: .contain,
                ),
              )
            else
              Positioned.fromRect(
                rect: _onScene(_bedRect),
                child: (bed.hasSprouts && !bed.isReady ? images.imgGryadkaRastet : images.imgGryadka).image(
                  fit: .contain,
                ),
              ),
            if (bed.isReady)
              Positioned.fromRect(
                rect: _onScene(_potatoesRect),
                child: images.imgPotatoOnGryadka.image(fit: .contain),
              ),
            if (bed.isPlanted)
              Positioned.fromRect(
                rect: _onScene(_timerRect),
                child: TimerContainer(
                  progress: bed.progress,
                  isDone: bed.isReady,
                ),
              ),
            Positioned.fromRect(
              rect: _onScene(_bedRect),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: .opaque,
                  onTap: () => _bloc.add(const GardenBedTapped()),
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
