import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class BackgroundElement extends Equatable {
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

  BackgroundElement copyWith({
    double? left,
    double? top,
    double? width,
    double? height,
    Widget? child,
  }) => BackgroundElement(
    left: left ?? this.left,
    top: top ?? this.top,
    width: width ?? this.width,
    height: height ?? this.height,
    child: child ?? this.child,
  );

  @override
  List<Object?> get props => [left, top, width, height, child];
}
