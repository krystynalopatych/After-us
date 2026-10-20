import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';

final class SceneContainer extends StatelessWidget {
  static const designSize = Size(1920, 1080);

  final List<Widget> children;

  const SceneContainer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DesignSystemTheme.of(context).colors.base.black,
      child: Center(
        child: FittedBox(
          child: SizedBox.fromSize(
            size: designSize,
            child: ClipRect(
              child: Stack(children: children),
            ),
          ),
        ),
      ),
    );
  }
}
