import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class MessageContainer extends StatelessWidget {
  static const _contentWidthFactor = 0.76;
  static const _contentHeightFactor = 0.6;
  static const _contentAlignment = Alignment(0, 0.15);
  static const _lineSpacing = 12.0;
  static const _actionsSpacing = 24.0;
  static const _actionSpacing = 24.0;

  final List<String> lines;
  final Size actionSize;
  final List<Widget> actions;

  const MessageContainer({
    super.key,
    required this.lines,
    required this.actionSize,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return Stack(
      fit: .expand,
      children: [
        Assets.resources.assets.images.imgMessageBlock.image(fit: .fill),
        Align(
          alignment: _contentAlignment,
          child: FractionallySizedBox(
            widthFactor: _contentWidthFactor,
            heightFactor: _contentHeightFactor,
            child: FittedBox(
              fit: .scaleDown,
              child: Column(
                mainAxisSize: .min,
                spacing: _lineSpacing,
                children: [
                  for (final line in lines)
                    Text(
                      line,
                      textAlign: .center,
                      style: theme.typography.display.copyWith(color: theme.colors.base.white),
                    ),
                  const SizedBox(height: _actionsSpacing - _lineSpacing),
                  Row(
                    mainAxisSize: .min,
                    spacing: _actionSpacing,
                    children: [
                      for (final action in actions) SizedBox.fromSize(size: actionSize, child: action),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
