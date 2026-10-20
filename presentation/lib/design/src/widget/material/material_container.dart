import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class MaterialContainer extends StatelessWidget {
  static const _itemAlignment = Alignment(0.085, -0.234);
  static const _itemSizeFactor = 0.45;
  static const _countAlignment = Alignment(0.598, 0.236);

  final AssetGenImage frame;
  final AssetGenImage image;
  final int count;

  const MaterialContainer({
    super.key,
    required this.frame,
    required this.image,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return Stack(
      fit: .expand,
      children: [
        frame.image(fit: .contain),
        Align(
          alignment: _itemAlignment,
          child: FractionallySizedBox(
            widthFactor: _itemSizeFactor,
            heightFactor: _itemSizeFactor,
            child: image.image(fit: .contain),
          ),
        ),
        Align(
          alignment: _countAlignment,
          child: Text(
            '$count',
            style: theme.typography.title.copyWith(color: theme.colors.base.black),
          ),
        ),
      ],
    );
  }
}
