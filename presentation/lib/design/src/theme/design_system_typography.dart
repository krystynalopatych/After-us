import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:presentation/generated/assets/fonts.gen.dart';

final class DesignSystemTypography extends Equatable {
  static const _noLigatures = [FontFeature.disable('liga')];

  final TextStyle banner;
  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle body;
  final TextStyle caption;
  final TextStyle handwriting;

  const DesignSystemTypography({
    required this.banner,
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.caption,
    required this.handwriting,
  });

  factory DesignSystemTypography.main(Color color) {
    return DesignSystemTypography(
      banner: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 120,
        height: 136 / 120,
        fontWeight: .w700,
        color: color,
        fontFeatures: _noLigatures,
      ),
      display: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 48,
        height: 56 / 48,
        fontWeight: .w700,
        color: color,
        fontFeatures: _noLigatures,
      ),
      headline: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 32,
        height: 40 / 32,
        fontWeight: .w700,
        color: color,
        fontFeatures: _noLigatures,
      ),
      title: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 20,
        height: 28 / 20,
        fontWeight: .w600,
        color: color,
        fontFeatures: _noLigatures,
      ),
      body: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: .w400,
        color: color,
        fontFeatures: _noLigatures,
      ),
      caption: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 12,
        height: 16 / 12,
        fontWeight: .w400,
        color: color,
        fontFeatures: _noLigatures,
      ),
      handwriting: TextStyle(
        fontFamily: FontFamily.pixelifySans,
        fontSize: 24,
        height: 30 / 24,
        fontWeight: .w600,
        color: color,
        fontFeatures: _noLigatures,
      ),
    );
  }

  @override
  List<Object> get props => [
    banner,
    display,
    headline,
    title,
    body,
    caption,
    handwriting,
  ];
}
