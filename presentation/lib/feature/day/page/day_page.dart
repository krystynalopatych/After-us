import 'package:domain/day/model/game_day.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/day/bloc/day_bloc.dart';

class DayPage extends StatefulWidget {
  final GameLevel level;

  const DayPage._({required this.level});

  static Widget withBloc({required GameLevel level}) => BlocProvider(
    create: (_) => DayBloc()..add(DayStarted(level)),
    child: DayPage._(level: level),
  );

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  static const _clockRight = 240.0;
  static const _clockTop = 24.0;
  static const _minutesPerHour = 60;
  static const _dayStartMinutes = 6 * _minutesPerHour;
  static const _dayEndMinutes = 20 * _minutesPerHour;
  static const _clockDigits = 2;

  late final DayBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final (colors, typography) = context.colorsTypography;

    return BlocBuilder<DayBloc, DayState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          Positioned(
            right: _clockRight,
            top: _clockTop,
            child: Column(
              crossAxisAlignment: .end,
              children: [
                Text(
                  'DAY ${state.day.number} / ${state.levelDays}',
                  style: typography.headline.copyWith(color: colors.base.white),
                ),
                Text(
                  _clockText(state.day),
                  style: typography.display.copyWith(color: colors.base.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _clockText(GameDay day) {
    final minutes = _dayStartMinutes + (_dayEndMinutes - _dayStartMinutes) * day.seconds ~/ GameDay.secondsPerDay;
    return '${_twoDigits(minutes ~/ _minutesPerHour)}:${_twoDigits(minutes % _minutesPerHour)}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(
    _clockDigits,
    '0',
  );
}
