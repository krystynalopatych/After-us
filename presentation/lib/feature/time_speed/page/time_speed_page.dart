import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/time_speed/bloc/time_speed_bloc.dart';

class TimeSpeedPage extends StatefulWidget {
  const TimeSpeedPage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => TimeSpeedBloc()..add(const TimeSpeedStarted()),
    child: const TimeSpeedPage._(),
  );

  @override
  State<TimeSpeedPage> createState() => _TimeSpeedPageState();
}

class _TimeSpeedPageState extends State<TimeSpeedPage> {
  static const _buttonRight = 470.0;
  static const _buttonTop = 24.0;
  static const _buttonWidth = 116.0;
  static const _buttonHeight = 96.0;
  static const _slowOpacity = 0.5;
  static const _opacityDuration = Duration(milliseconds: 200);

  late final TimeSpeedBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeSpeedBloc, TimeSpeedState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          Positioned(
            right: _buttonRight,
            top: _buttonTop,
            width: _buttonWidth,
            height: _buttonHeight,
            child: AnimatedOpacity(
              opacity: state.isFast ? 1 : _slowOpacity,
              duration: _opacityDuration,
              child: PressableContainer(
                image: context.images.imgTimeSpeed,
                isEnabled: !state.isNight,
                onTap: () => _bloc.add(const TimeSpeedToggled()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
