import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/design/src/widget/label/label_container.dart';
import 'package:presentation/design/src/widget/pressable_container/tap_builder.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class AnswerButtonContainer extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isDone;
  final String? hint;

  const AnswerButtonContainer({
    super.key,
    required this.text,
    required this.onTap,
    this.isEnabled = true,
    this.isDone = false,
    this.hint,
  });

  @override
  State<AnswerButtonContainer> createState() => _AnswerButtonContainerState();
}

class _AnswerButtonContainerState extends State<AnswerButtonContainer> {
  static const _animationDuration = Duration(milliseconds: 120);
  static const _pressedScale = 0.92;
  static const _disabledShadeOpacity = 0.5;
  static const _doneHeightFactor = 0.8;
  static const _hintOffset = Offset(
    16,
    0,
  );
  static const _textPadding = EdgeInsets.symmetric(
    horizontal: 40,
    vertical: 32,
  );

  final _hintLink = LayerLink();
  final _hintController = OverlayPortalController()..show();

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);

    return TapBuilder(
      onTap: widget.onTap,
      isEnabled: widget.isEnabled,
      builder: (context, isPressed, isHovered) => OverlayPortal(
        controller: _hintController,
        overlayChildBuilder: (context) => _hint(isHovered),
        child: CompositedTransformTarget(
          link: _hintLink,
          child: AnimatedScale(
            scale: isPressed ? _pressedScale : 1,
            duration: _animationDuration,
            curve: Curves.easeOut,
            child: Stack(
              fit: .expand,
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    theme.colors.base.black.withValues(alpha: widget.isEnabled ? 0 : _disabledShadeOpacity),
                    .srcATop,
                  ),
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
                              widget.text,
                              style: theme.typography.headline.copyWith(
                                color: widget.isEnabled && (isPressed || isHovered)
                                    ? theme.colors.base.orange
                                    : theme.colors.base.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isDone)
                  Center(
                    child: FractionallySizedBox(
                      heightFactor: _doneHeightFactor,
                      child: Assets.resources.assets.images.imgDoneIcon.image(fit: .contain),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hint(bool isHovered) {
    final hint = widget.hint;
    if (hint == null || widget.isEnabled || !isHovered) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: .topLeft,
      child: IgnorePointer(
        child: CompositedTransformFollower(
          link: _hintLink,
          targetAnchor: .centerRight,
          followerAnchor: .centerLeft,
          offset: _hintOffset,
          child: LabelContainer(text: hint),
        ),
      ),
    );
  }
}
