import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/game_over/bloc/game_over_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage._();

  static Widget withBloc({required GameLevel level}) => BlocProvider(
    create: (_) => GameOverBloc(level: level)..add(const GameOverStarted()),
    child: const GameOverPage._(),
  );

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  static const _spacing = 24.0;
  static const _actionsTopSpacing = 48.0;
  static const _actionSize = Size(
    320,
    192,
  );

  late final GameOverBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final (colors, typography) = context.colorsTypography;

    return BlocConsumer<GameOverBloc, GameOverState>(
      bloc: _bloc,
      listenWhen: (previous, current) => !previous.isCompleted && current.isCompleted,
      listener: (context, state) => AppRoute.levels.go(context),
      builder: (context, state) {
        final result = state.result;
        if (result == null) {
          return const SizedBox.shrink();
        }
        final color = result.outcome == .won ? colors.base.green : colors.base.red;

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
                    _title(result.outcome),
                    style: typography.banner.copyWith(color: color),
                  ),
                  if (_reason(result.outcome) case final reason?)
                    Text(
                      reason,
                      textAlign: .center,
                      style: typography.display.copyWith(color: color),
                    ),
                  const SizedBox(height: _actionsTopSpacing - _spacing),
                  Row(
                    mainAxisSize: .min,
                    spacing: _spacing,
                    children: [
                      if (result.outcome == .won)
                        _action(
                          'CONTINUE',
                          () => _bloc.add(const GameOverContinueTapped()),
                        )
                      else ...[
                        _action(
                          'RETRY',
                          () => _bloc.add(const GameOverRetryTapped()),
                        ),
                        _action(
                          'MENU',
                          () => AppRoute.start.go(context),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _action(
    String text,
    VoidCallback onTap,
  ) => SizedBox.fromSize(
    size: _actionSize,
    child: AnswerButtonContainer(
      text: text,
      onTap: onTap,
    ),
  );

  static String _title(LevelOutcome outcome) => switch (outcome) {
    .won => 'YOU WON!',
    .died || .noTimeLeft => 'YOU LOST',
  };

  static String? _reason(LevelOutcome outcome) => switch (outcome) {
    .won => null,
    .died => 'YOU DIED',
    .noTimeLeft => 'NO TIME LEFT',
  };
}
