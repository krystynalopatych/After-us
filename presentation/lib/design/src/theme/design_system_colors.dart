import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class DesignSystemColors extends Equatable {
  final BaseColors base;

  const DesignSystemColors({
    required this.base,
  });

  const DesignSystemColors.light() : base = const .light();

  const DesignSystemColors.dark() : base = const .dark();

  @override
  List<Object> get props => [
    base,
  ];
}

final class BaseColors extends Equatable {
  final Color white;
  final Color black;
  final Color red;
  final Color green;
  final Color blue;
  final Color yellow;
  final Color orange;
  final Color purple;
  final Color pink;
  final Color grey;
  final Color brown;

  const BaseColors.light()
    : white = const .new(0xFFFFFFFF),
      black = const .new(0xFF000000),
      red = const .new(0xFFE53935),
      green = const .new(0xFF43A047),
      blue = const .new(0xFF1E88E5),
      yellow = const .new(0xFFFDD835),
      orange = const .new(0xFFFB8C00),
      purple = const .new(0xFF8E24AA),
      pink = const .new(0xFFD81B60),
      grey = const .new(0xFF9E9E9E),
      brown = const .new(0xFF3C2210);

  const BaseColors.dark()
    : white = const .new(0xFFFFFFFF),
      black = const .new(0xFF000000),
      red = const .new(0xFFE53935),
      green = const .new(0xFF43A047),
      blue = const .new(0xFF1E88E5),
      yellow = const .new(0xFFFDD835),
      orange = const .new(0xFFFB8C00),
      purple = const .new(0xFF8E24AA),
      pink = const .new(0xFFD81B60),
      grey = const .new(0xFF9E9E9E),
      brown = const .new(0xFF3C2210);

  @override
  List<Object> get props => [
    white,
    black,
    red,
    green,
    blue,
    yellow,
    orange,
    purple,
    pink,
    grey,
    brown,
  ];
}
