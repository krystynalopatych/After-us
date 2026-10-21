import 'dart:math';

import 'package:domain/day/model/game_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/night/bloc/night_bloc.dart';

class NightPage extends StatefulWidget {
  const NightPage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => NightBloc()..add(const NightStarted()),
    child: const NightPage._(),
  );

  @override
  State<NightPage> createState() => _NightPageState();
}

class _NightPageState extends State<NightPage> with SingleTickerProviderStateMixin {
  static const _fadeDuration = Duration(milliseconds: 500);
  static const _moonSize = 260.0;
  static const _moonStartX = 160.0;
  static const _moonEndX = 1500.0;
  static const _moonBaseY = 560.0;
  static const _moonArcHeight = 220.0;
  static const _textBottom = 360.0;

  late final NightBloc _bloc;
  late final AnimationController _moon;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _moon = AnimationController(
      vsync: this,
      duration: const Duration(seconds: GameDay.nightLength),
    );
    if (_bloc.state.isNight) {
      _moon.forward(from: _bloc.state.progress);
    }
  }

  @override
  void dispose() {
    _moon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (colors, typography) = context.colorsTypography;

    return BlocConsumer<NightBloc, NightState>(
      bloc: _bloc,
      listenWhen: (previous, current) => !previous.isNight && current.isNight,
      listener: (context, state) => _moon.forward(from: state.progress),
      builder: (context, state) => IgnorePointer(
        ignoring: !state.isNight,
        child: AnimatedOpacity(
          opacity: state.isNight ? 1 : 0,
          duration: _fadeDuration,
          child: ColoredBox(
            color: colors.base.black,
            child: Stack(
              fit: .expand,
              children: [
                AnimatedBuilder(
                  animation: _moon,
                  builder: (context, child) => Positioned(
                    left: _moonStartX + (_moonEndX - _moonStartX) * _moon.value,
                    top: _moonBaseY - _moonArcHeight * sin(pi * _moon.value),
                    width: _moonSize,
                    height: _moonSize,
                    child: child!,
                  ),
                  child: context.images.imgMoon.image(fit: .contain),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: _textBottom,
                  child: Text(
                    'YOU NEED TO SLEEP',
                    textAlign: .center,
                    style: typography.banner.copyWith(color: colors.base.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
