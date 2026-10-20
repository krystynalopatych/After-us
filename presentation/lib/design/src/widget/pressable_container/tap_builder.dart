import 'package:flutter/material.dart';

typedef TapWidgetBuilder = Widget Function(
  BuildContext context,
  bool isPressed,
  bool isHovered,
);

final class TapBuilder extends StatefulWidget {
  final VoidCallback onTap;
  final TapWidgetBuilder builder;
  final bool isEnabled;

  const TapBuilder({
    super.key,
    required this.onTap,
    required this.builder,
    this.isEnabled = true,
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
      cursor: widget.isEnabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: .opaque,
        onTapDown: widget.isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: widget.isEnabled ? widget.onTap : null,
        child: widget.builder(
          context,
          _isPressed,
          _isHovered,
        ),
      ),
    );
  }
}
