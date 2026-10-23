import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class HeroLineContainer extends StatefulWidget {
  final String text;
  final VoidCallback? onTyped;

  const HeroLineContainer({
    super.key,
    required this.text,
    this.onTyped,
  });

  @override
  State<HeroLineContainer> createState() => _HeroLineContainerState();
}

class _HeroLineContainerState extends State<HeroLineContainer> with SingleTickerProviderStateMixin {
  static const _contentWidthFactor = 0.78;
  static const _contentHeightFactor = 0.5;
  static const _letterDuration = Duration(milliseconds: 40);

  late final AnimationController _typing;

  @override
  void initState() {
    super.initState();
    _typing = AnimationController(
      vsync: this,
      duration: _letterDuration * widget.text.length,
    )..forward().whenComplete(() => widget.onTyped?.call());
  }

  @override
  void dispose() {
    _typing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    final style = theme.typography.headline.copyWith(color: theme.colors.base.black);

    return Stack(
      fit: .expand,
      children: [
        Assets.resources.assets.images.imgDialogue.image(fit: .fill),
        Center(
          child: FractionallySizedBox(
            widthFactor: _contentWidthFactor,
            heightFactor: _contentHeightFactor,
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: FittedBox(
                  fit: .scaleDown,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: AnimatedBuilder(
                      animation: _typing,
                      builder: (context, child) {
                        final shown = (widget.text.length * _typing.value).floor();
                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: widget.text.substring(0, shown)),
                              TextSpan(
                                text: widget.text.substring(shown),
                                style: style.copyWith(color: style.color?.withValues(alpha: 0)),
                              ),
                            ],
                          ),
                          textAlign: .center,
                          style: style,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
