import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/design/src/widget/pressable_container/tap_builder.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class SelectableContainer extends StatelessWidget {
  static const _glowBlurSigma = 6.0;
  static const _glowScale = 1.35;
  static const _labelOpacity = 0.8;
  static const _labelRadius = BorderRadius.all(Radius.circular(8));
  static const _labelPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  final AssetGenImage glowImage;
  final String label;
  final bool isSelected;
  final bool isLabelBelow;
  final VoidCallback onTap;
  final Widget child;

  const SelectableContainer({
    super.key,
    required this.glowImage,
    required this.label,
    required this.isSelected,
    required this.isLabelBelow,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, isPressed, isHovered) => Stack(
        fit: .expand,
        clipBehavior: .none,
        children: [
          if (isSelected)
            Transform.scale(
              scale: _glowScale,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: _glowBlurSigma, sigmaY: _glowBlurSigma),
                child: glowImage.image(
                  fit: .contain,
                  color: theme.colors.base.yellow,
                  colorBlendMode: .srcIn,
                ),
              ),
            ),
          child,
          if (isHovered)
            Positioned.fill(
              child: Align(
                alignment: isLabelBelow ? .bottomCenter : .topCenter,
                child: FractionalTranslation(
                  translation: Offset(0, isLabelBelow ? 1 : -1),
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    fit: .deferToChild,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colors.base.black.withValues(alpha: _labelOpacity),
                        borderRadius: _labelRadius,
                      ),
                      child: Padding(
                        padding: _labelPadding,
                        child: Text(
                          label,
                          style: theme.typography.headline.copyWith(color: theme.colors.base.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
