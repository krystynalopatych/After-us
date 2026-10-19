import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class DesignSystemTypography extends Equatable {
  final TextStyle headline;
  final TextStyle title;
  final TextStyle body;
  final TextStyle caption;

  const DesignSystemTypography({
    required this.headline,
    required this.title,
    required this.body,
    required this.caption,
  });

  factory DesignSystemTypography.main(Color color) {
    return DesignSystemTypography(
      headline: TextStyle(fontSize: 32, height: 40 / 32, fontWeight: .w700, color: color),
      title: TextStyle(fontSize: 20, height: 28 / 20, fontWeight: .w600, color: color),
      body: TextStyle(fontSize: 16, height: 24 / 16, fontWeight: .w400, color: color),
      caption: TextStyle(fontSize: 12, height: 16 / 12, fontWeight: .w400, color: color),
    );
  }

  @override
  List<Object> get props => [
    headline,
    title,
    body,
    caption,
  ];
}
