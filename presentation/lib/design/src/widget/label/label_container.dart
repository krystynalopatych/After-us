import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';

final class LabelContainer extends StatelessWidget {
  static const _opacity = 0.8;
  static const _radius = BorderRadius.all(Radius.circular(8));
  static const _padding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );

  final String text;

  const LabelContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.base.black.withValues(alpha: _opacity),
        borderRadius: _radius,
      ),
      child: Padding(
        padding: _padding,
        child: Text(
          text,
          style: theme.typography.headline.copyWith(color: theme.colors.base.white),
        ),
      ),
    );
  }
}
