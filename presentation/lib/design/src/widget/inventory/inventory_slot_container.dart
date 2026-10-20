import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class InventorySlotContainer extends StatelessWidget {
  final AssetGenImage image;
  final int count;

  const InventorySlotContainer({
    super.key,
    required this.image,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return Stack(
      fit: .expand,
      children: [
        image.image(fit: .contain),
        Align(
          alignment: .bottomRight,
          child: Text(
            '$count',
            style: theme.typography.body.copyWith(color: theme.colors.base.white),
          ),
        ),
      ],
    );
  }
}
