import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class InventorySlotContainer extends StatelessWidget {
  static const _spoiledTintOpacity = 0.55;

  final AssetGenImage image;
  final int count;
  final bool isSpoiled;

  const InventorySlotContainer({
    super.key,
    required this.image,
    required this.count,
    this.isSpoiled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return Stack(
      fit: .expand,
      children: [
        if (isSpoiled)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              theme.colors.base.green.withValues(alpha: _spoiledTintOpacity),
              BlendMode.srcATop,
            ),
            child: image.image(fit: .contain),
          )
        else
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
