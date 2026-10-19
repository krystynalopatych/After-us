import 'package:flutter/material.dart';

final class BackgroundElement {
  final double left;
  final double top;
  final double width;
  final double height;
  final Widget child;

  const BackgroundElement({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.child,
  });
}
