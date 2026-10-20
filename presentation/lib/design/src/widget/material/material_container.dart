import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class MaterialContainer extends StatelessWidget {
  static const _itemAlignment = Alignment(0.085, -0.234);
  static const _itemSizeFactor = 0.45;
  static const _countCenter = Offset(0.799, 0.622);
  static const _countSizeFactor = 0.11;
  static const _countHeightBehavior = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

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
            Positioned.fromRect(
              rect: Rect.fromCenter(
                center: Offset(_countCenter.dx * size.width, _countCenter.dy * size.height),
                width: _countSizeFactor * size.width,
                height: _countSizeFactor * size.height,
              ),
              child: FittedBox(
                fit: .scaleDown,
                child: Text(
                  '$count',
                  textHeightBehavior: _countHeightBehavior,
                  style: theme.typography.title.copyWith(color: theme.colors.base.black, height: 1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
