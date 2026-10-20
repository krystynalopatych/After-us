import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class HeroLineContainer extends StatelessWidget {
  static const _contentWidthFactor = 0.78;
  static const _contentHeightFactor = 0.5;

  final String text;

  const HeroLineContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return Stack(
      fit: .expand,
      children: [
        Assets.resources.assets.images.imgDialogue.image(fit: .fill),
        Center(
          child: FractionallySizedBox(
            widthFactor: _contentWidthFactor,
            heightFactor: _contentHeightFactor,
            child: Center(
              child: FittedBox(
                fit: .scaleDown,
                child: Text(
                  text,
                  textAlign: .center,
                  style: theme.typography.headline.copyWith(color: theme.colors.base.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
