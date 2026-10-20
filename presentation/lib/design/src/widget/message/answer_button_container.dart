import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/design/src/widget/pressable_container/tap_builder.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class AnswerButtonContainer extends StatelessWidget {
  static const _animationDuration = Duration(milliseconds: 120);
  static const _pressedScale = 0.92;
  static const _textPadding = EdgeInsets.symmetric(horizontal: 40, vertical: 32);

  final String text;
  final VoidCallback onTap;

  const AnswerButtonContainer({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, isPressed, isHovered) => AnimatedScale(
        scale: isPressed ? _pressedScale : 1,
        duration: _animationDuration,
        curve: Curves.easeOut,
        child: Stack(
          fit: .expand,
          children: [
            Assets.resources.assets.images.imgAnswerBlock.image(fit: .fill),
            Padding(
              padding: _textPadding,
              child: Center(
                child: FittedBox(
                  fit: .scaleDown,
                  child: Text(
                    text,
                    style: theme.typography.headline.copyWith(
                      color: isPressed || isHovered ? theme.colors.base.orange : theme.colors.base.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
