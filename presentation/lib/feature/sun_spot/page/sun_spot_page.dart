import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/item_image_extension.dart';
import 'package:presentation/feature/sun_spot/bloc/sun_spot_bloc.dart';

class SunSpotPage extends StatefulWidget {
  final double locationTop;

  const SunSpotPage._({required this.locationTop});

  static Widget withBloc({required double locationTop}) => BlocProvider(
    create: (_) => SunSpotBloc()..add(const SunSpotStarted()),
    child: SunSpotPage._(locationTop: locationTop),
  );

  @override
  State<SunSpotPage> createState() => _SunSpotPageState();
}

class _SunSpotPageState extends State<SunSpotPage> {
  static const _spotRect = Rect.fromLTWH(
    770,
    800,
    440,
    240,
  );
  static const _bottleRect = Rect.fromLTWH(
    900,
    800,
    180,
    180,
  );
  static const _timerRect = Rect.fromLTWH(
    930,
    670,
    120,
    120,
  );

  late final SunSpotBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SunSpotBloc, SunSpotState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          if (state.bottle case final bottle?) ...[
            Positioned.fromRect(
              rect: _onScene(_bottleRect),
              child: bottle.item.asset(context).image(fit: .contain),
            ),
            Positioned.fromRect(
              rect: _onScene(_timerRect),
              child: TimerContainer(
                progress: bottle.progress,
                isDone: bottle.isReady,
              ),
            ),
          ],
          Positioned.fromRect(
            rect: _onScene(_spotRect),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: .opaque,
                onTap: () => _bloc.add(const SunSpotTapped()),
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
