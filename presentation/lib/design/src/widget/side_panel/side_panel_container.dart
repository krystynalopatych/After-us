import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';

final class SidePanelContainer extends StatelessWidget {
  static const _animationDuration = Duration(milliseconds: 250);
  static const _shadeOpacity = 0.6;

  final bool isOpen;
  final double width;
  final Widget child;

  const SidePanelContainer({
    super.key,
    required this.isOpen,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DesignSystemTheme.of(context).colors;

    return Align(
      alignment: .centerRight,
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: AnimatedSlide(
          offset: isOpen
              ? Offset.zero
              : const Offset(
                  1,
                  0,
                ),
          duration: _animationDuration,
          curve: Curves.easeOut,
          child: ColoredBox(
            color: colors.base.black.withValues(alpha: _shadeOpacity),
            child: child,
          ),
        ),
      ),
    );
  }
}
