import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';

final class LoadingContainer extends StatelessWidget {
  static const _barSize = Size(
    640,
    32,
  );
  static const _borderWidth = 4.0;
  static const _barPadding = 6.0;
  static const _spacing = 32.0;

  final double progress;

  const LoadingContainer({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    final colors = theme.colors.base;

    return ColoredBox(
      color: colors.black,
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: _spacing,
          children: [
            Text(
              'LOADING ${(progress * 100).round()}%',
              style: theme.typography.display.copyWith(color: colors.white),
            ),
            Container(
              width: _barSize.width,
              height: _barSize.height,
              padding: const EdgeInsets.all(_barPadding),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.white,
                  width: _borderWidth,
                ),
              ),
              child: Align(
                alignment: .centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: ColoredBox(color: colors.yellow),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
