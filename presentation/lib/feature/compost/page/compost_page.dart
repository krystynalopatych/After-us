import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/compost/bloc/compost_bloc.dart';

class CompostPage extends StatefulWidget {
  final double locationTop;

  const CompostPage._({required this.locationTop});

  static Widget withBloc({required double locationTop}) => BlocProvider(
    create: (_) => CompostBloc()..add(const CompostStarted()),
    child: CompostPage._(locationTop: locationTop),
  );

  @override
  State<CompostPage> createState() => _CompostPageState();
}

class _CompostPageState extends State<CompostPage> {
  static const _pitRect = Rect.fromLTWH(
    190,
    330,
    230,
    210,
  );
  static const _pileSize = Size(
    70,
    60,
  );
  static const _pileSpots = [
    Offset(
      250,
      410,
    ),
    Offset(
      305,
      400,
    ),
    Offset(
      270,
      450,
    ),
    Offset(
      325,
      445,
    ),
  ];
  static const _timerRect = Rect.fromLTWH(
    250,
    220,
    110,
    110,
  );

  late final CompostBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final images = context.images;

    return BlocBuilder<CompostBloc, CompostState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          Positioned.fromRect(
            rect: _onScene(_pitRect),
            child: images.imgHole.image(fit: .contain),
          ),
          for (final spot in _pileSpots.take(state.pit.organics))
            Positioned.fromRect(
              rect: _onScene(spot & _pileSize),
              child: images.imgOrganic.image(fit: .contain),
            ),
          if (state.pit.isFull)
            Positioned.fromRect(
              rect: _onScene(_timerRect),
              child: TimerContainer(
                progress: state.pit.progress,
                isDone: state.pit.isReady,
              ),
            ),
          Positioned.fromRect(
            rect: _onScene(_pitRect),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: .opaque,
                onTap: () => _bloc.add(const CompostPitTapped()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Rect _onScene(Rect rect) => rect.translate(
    0,
    widget.locationTop,
  );
}
