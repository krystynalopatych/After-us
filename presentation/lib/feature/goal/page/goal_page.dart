import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/item_title_extension.dart';
import 'package:presentation/feature/goal/bloc/goal_bloc.dart';

class GoalPage extends StatefulWidget {
  final GameLevel level;

  const GoalPage._({required this.level});

  static Widget withBloc({required GameLevel level}) => BlocProvider(
    create: (_) => GoalBloc()..add(const GoalStarted()),
    child: GoalPage._(level: level),
  );

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  static const _listRight = 240.0;
  static const _listTop = 170.0;
  static const _rowSpacing = 8.0;
  static const _iconSpacing = 16.0;
  static const _iconSize = Size(
    56,
    44,
  );
  static const _pendingOpacity = 0.2;
  static const _doneDuration = Duration(milliseconds: 200);

  late final GoalBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final (colors, typography) = context.colorsTypography;
    final images = context.images;

    return BlocBuilder<GoalBloc, GoalState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          Positioned(
            right: _listRight,
            top: _listTop,
            child: IgnorePointer(
              child: Column(
                crossAxisAlignment: .end,
                spacing: _rowSpacing,
                children: [
                  for (final goal in widget.level.goals)
                    Row(
                      mainAxisSize: .min,
                      spacing: _iconSpacing,
                      children: [
                        Text(
                          goal.title,
                          style: typography.headline.copyWith(color: colors.base.white),
                        ),
                        SizedBox.fromSize(
                          size: _iconSize,
                          child: AnimatedOpacity(
                            opacity: state.built.contains(goal) ? 1 : _pendingOpacity,
                            duration: _doneDuration,
                            child: images.imgDoneIcon.image(fit: .contain),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
