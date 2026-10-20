import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class StatContainer extends StatelessWidget {
  final AssetGenImage image;
  final int value;
  final Alignment valueAlignment;

  const StatContainer({
    super.key,
    required this.image,
    required this.value,
    required this.valueAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return Stack(
      fit: .expand,
      children: [
        image.image(fit: .contain),
        Align(
          alignment: valueAlignment,
          child: Text(
            '$value',
            style: theme.typography.headline.copyWith(color: theme.colors.base.white),
          ),
        ),
      ],
    );
  }
}
