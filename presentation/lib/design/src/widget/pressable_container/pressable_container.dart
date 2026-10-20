import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/design/src/widget/pressable_container/tap_builder.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class PressableContainer extends StatelessWidget {
  static const _animationDuration = Duration(milliseconds: 120);
  static const _pressedScale = 0.9;
  static const _glowBlurSigma = 12.0;
  static const _disabledShadeOpacity = 0.4;

  final AssetGenImage image;
  final VoidCallback onTap;
  final Color? highlightColor;
  final bool isEnabled;

  const PressableContainer({
    super.key,
    required this.image,
    required this.onTap,
    this.highlightColor,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DesignSystemTheme.of(context).colors;

    if (!isEnabled) {
      return image.image(
        fit: .contain,
        color: colors.base.black.withValues(alpha: _disabledShadeOpacity),
        colorBlendMode: .srcATop,
      );
    }

    return TapBuilder(
      onTap: onTap,
      builder: (context, isPressed, isHovered) => AnimatedScale(
        scale: isPressed ? _pressedScale : 1,
        duration: _animationDuration,
        curve: Curves.easeOut,
        child: Stack(
          fit: .expand,
          clipBehavior: .none,
          children: [
            AnimatedOpacity(
              opacity: isPressed || isHovered ? 1 : 0,
              duration: _animationDuration,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: _glowBlurSigma,
                  sigmaY: _glowBlurSigma,
                ),
                child: image.image(
                  fit: .contain,
                  color: highlightColor ?? colors.base.white,
                  colorBlendMode: .srcIn,
                ),
              ),
            ),
            image.image(fit: .contain),
          ],
        ),
      ),
    );
  }
}
