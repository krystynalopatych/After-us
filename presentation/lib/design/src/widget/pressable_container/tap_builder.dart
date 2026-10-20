import 'package:flutter/material.dart';

typedef TapWidgetBuilder = Widget Function(
  BuildContext context,
  bool isPressed,
  bool isHovered,
);

final class TapBuilder extends StatefulWidget {
  final VoidCallback onTap;
  final TapWidgetBuilder builder;

  const TapBuilder({
    super.key,
    required this.onTap,
    required this.builder,
  });

  @override
  State<TapBuilder> createState() => _TapBuilderState();
}

class _TapBuilderState extends State<TapBuilder> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: .opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: widget.builder(
          context,
          _isPressed,
          _isHovered,
        ),
      ),
    );
  }
}
