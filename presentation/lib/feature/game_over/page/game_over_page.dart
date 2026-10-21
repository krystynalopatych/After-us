import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/model/level_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/item_title_extension.dart';
import 'package:presentation/feature/game_over/bloc/game_over_bloc.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

class GameOverPage extends StatefulWidget {
  final VoidCallback onRetry;

  const GameOverPage._({required this.onRetry});

  static Widget withBloc({
    required GameLevel level,
    required VoidCallback onRetry,
  }) => BlocProvider(
    create: (_) => GameOverBloc(level: level)..add(const GameOverStarted()),
    child: GameOverPage._(onRetry: onRetry),
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
                  if (_reason(result) case final reason?)
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
                          widget.onRetry,
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
    .died => 'YOU DIED',
    .noTimeLeft => 'YOU LOST',
  };

  static String? _reason(LevelResult result) => switch (result.outcome) {
    .won || .died => null,
    .noTimeLeft => 'You did not finish ${_goalList(result.missingGoals)}.',
  };

  static String _goalList(List<Construction> goals) {
    final names = [
      for (final goal in goals) 'the ${goal.title.toLowerCase()}',
    ];
    if (names.length < 2) {
      return names.join();
    }
    return '${names.take(names.length - 1).join(', ')} and ${names.last}';
  }
}
