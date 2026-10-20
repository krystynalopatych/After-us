import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';

final class SceneContainer extends StatelessWidget {
  static const designSize = Size(1920, 1080);

  final Size size;
  final List<Widget> children;

  const SceneContainer({
    super.key,
    this.size = designSize,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DesignSystemTheme.of(context).colors.base.black,
      child: Center(
        child: FittedBox(
          child: SizedBox.fromSize(
            size: size,
            child: ClipRect(
              child: Stack(children: children),
            ),
          ),
        ),
      ),
    );
  }
}
