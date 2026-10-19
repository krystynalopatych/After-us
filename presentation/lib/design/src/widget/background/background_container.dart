import 'package:flutter/material.dart';
import 'package:presentation/design/src/widget/background/model/background_element.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class BackgroundContainer extends StatelessWidget {
  final AssetGenImage image;
  final List<BackgroundElement> elements;

  const BackgroundContainer({
    super.key,
    required this.image,
    this.elements = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        image.image(fit: .cover),
        for (final element in elements)
          Positioned(
            left: element.left,
            top: element.top,
            width: element.width,
            height: element.height,
            child: element.child,
          ),
      ],
    );
  }
}
