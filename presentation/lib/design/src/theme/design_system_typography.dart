import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:presentation/generated/assets/fonts.gen.dart';

final class DesignSystemTypography extends Equatable {
  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle body;
  final TextStyle caption;

  const DesignSystemTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.caption,
  });

  factory DesignSystemTypography.main(Color color) {
    return DesignSystemTypography(
      display: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 48,
        height: 56 / 48,
        fontWeight: .w700,
        color: color,
      ),
      headline: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 32,
        height: 40 / 32,
        fontWeight: .w700,
        color: color,
      ),
      title: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 20,
        height: 28 / 20,
        fontWeight: .w600,
        color: color,
      ),
      body: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: .w400,
        color: color,
      ),
      caption: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 12,
        height: 16 / 12,
        fontWeight: .w400,
        color: color,
      ),
    );
  }

  @override
  List<Object> get props => [
    display,
    headline,
    title,
    body,
    caption,
  ];
}
