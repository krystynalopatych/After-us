import 'package:domain/day/model/level_outcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/game_over/bloc/game_over_bloc.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => GameOverBloc()..add(const GameOverStarted()),
    child: const GameOverPage._(),
  );

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  static const _spacing = 24.0;

  late final GameOverBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final (colors, typography) = context.colorsTypography;

    return BlocBuilder<GameOverBloc, GameOverState>(
      bloc: _bloc,
      builder: (context, state) {
        final outcome = state.outcome;
        if (outcome == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          behavior: .opaque,
          child: ColoredBox(
            color: colors.base.black,
            child: Center(
              child: Column(
                mainAxisSize: .min,
                spacing: _spacing,
                children: [
                  Text(
                    _title(outcome),
                    style: typography.banner.copyWith(color: colors.base.red),
                  ),
                  if (outcome == .noTimeLeft)
                    Text(
                      'NO TIME LEFT',
                      style: typography.display.copyWith(color: colors.base.red),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _title(LevelOutcome outcome) => switch (outcome) {
    .died => 'YOU DIED',
    .noTimeLeft => 'YOU LOST',
  };
}
