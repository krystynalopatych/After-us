import 'package:flutter/material.dart';
import 'package:presentation/design/src/widget/sky/model/sky_state.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class SkyContainer extends StatelessWidget {
  static const _changeDuration = Duration(seconds: 3);
  static final _images = Assets.resources.assets.images;

  final SkyState state;

  const SkyContainer({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        _images.imgSkyBlue.image(
          fit: .cover,
          alignment: .bottomCenter,
        ),
        AnimatedOpacity(
          opacity: state.isSkyDark ? 1 : 0,
          duration: _changeDuration,
          curve: Curves.easeInOut,
          child: _images.imgSkyBlack.image(
            fit: .cover,
            alignment: .bottomCenter,
          ),
        ),
      ],
    );
  }
}
