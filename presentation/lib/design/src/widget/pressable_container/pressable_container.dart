import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:presentation/design/src/widget/pressable_container/tap_builder.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class PressableContainer extends StatelessWidget {
  static const _animationDuration = Duration(milliseconds: 120);
  static const _pressedScale = 0.9;
  static const _glowBlurSigma = 12.0;

  final AssetGenImage image;
  final VoidCallback onTap;

  const PressableContainer({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                imageFilter: ImageFilter.blur(sigmaX: _glowBlurSigma, sigmaY: _glowBlurSigma),
                child: image.image(
                  fit: .contain,
                  color: Colors.white,
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
