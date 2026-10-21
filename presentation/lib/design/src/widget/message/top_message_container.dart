import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class TopMessageContainer extends StatelessWidget {
  static const _contentWidthFactor = 0.72;
  static const _contentHeightFactor = 0.5;

  final String text;

  const TopMessageContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return Stack(
      fit: .expand,
      children: [
        Assets.resources.assets.images.imgMessageBlock.image(fit: .fill),
        Center(
          child: FractionallySizedBox(
            widthFactor: _contentWidthFactor,
            heightFactor: _contentHeightFactor,
            child: Center(
              child: FittedBox(
                fit: .scaleDown,
                child: Text(
                  text.toUpperCase(),
                  textAlign: .center,
                  style: theme.typography.display.copyWith(color: theme.colors.base.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
