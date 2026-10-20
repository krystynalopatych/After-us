import 'package:flutter/material.dart';
import 'package:presentation/design/src/widget/sky/model/sky_state.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class SkyContainer extends StatefulWidget {
  final SkyState state;

  const SkyContainer({
    super.key,
    required this.state,
  });

  @override
  State<SkyContainer> createState() => _SkyContainerState();
}

class _SkyContainerState extends State<SkyContainer> with SingleTickerProviderStateMixin {
  static const _changeDuration = Duration(seconds: 3);
  static const _driftDuration = Duration(seconds: 120);
  static const _cloudAspectRatio = 2.0;
  static final _images = Assets.resources.assets.images;
  static final _clouds = [
    (image: _images.imgClaudBlue, top: 30.0, width: 620.0, darkFactor: 1.0, speed: 1, phase: 0.1),
    (image: _images.imgClaudBlueSmaller, top: 110.0, width: 700.0, darkFactor: 0.72, speed: 2, phase: 0.55),
    (image: _images.imgClaudBlue, top: 190.0, width: 460.0, darkFactor: 1.0, speed: 1, phase: 0.62),
    (image: _images.imgClaudBlueSmaller, top: 0.0, width: 560.0, darkFactor: 0.72, speed: 2, phase: 0.9),
  ];

  late final AnimationController _drift;

  @override
  void initState() {
    super.initState();
    _drift = AnimationController(vsync: this, duration: _driftDuration)..repeat();
  }

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          fit: .expand,
          children: [
            _images.imgSkyBlue.image(fit: .cover, alignment: .bottomCenter),
            _fade(
              isVisible: widget.state.isSkyDark,
              child: _images.imgSkyBlack.image(fit: .cover, alignment: .bottomCenter),
            ),
            for (final cloud in _clouds)
              AnimatedBuilder(
                animation: _drift,
                builder: (context, child) {
                  final travel = constraints.maxWidth + cloud.width;
                  final progress = (_drift.value * cloud.speed + cloud.phase) % 1;
                  return Positioned(
                    left: progress * travel - cloud.width,
                    top: cloud.top,
                    width: cloud.width,
                    height: cloud.width / _cloudAspectRatio,
                    child: child!,
                  );
                },
                child: Stack(
                  fit: .expand,
                  children: [
                    _fade(
                      isVisible: !widget.state.areCloudsDark,
                      child: cloud.image.image(fit: .contain),
                    ),
                    _fade(
                      isVisible: widget.state.areCloudsDark,
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: cloud.darkFactor,
                          heightFactor: cloud.darkFactor,
                          child: _images.imgClaudBlack.image(fit: .contain),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _fade({required bool isVisible, required Widget child}) => AnimatedOpacity(
    opacity: isVisible ? 1 : 0,
    duration: _changeDuration,
    curve: Curves.easeInOut,
    child: child,
  );
}
