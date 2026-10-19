import 'package:flutter/material.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

extension BuildContextExtension on BuildContext {
  bool get isDarkMode => DesignSystemTheme.isDarkTheme(this);

  $AssetsImagesGen get images => Assets.images;

  (DesignSystemColors, DesignSystemTypography) get colorsTypography => (colors, typography);

  DesignSystemColors get colors => _theme.colors;

  DesignSystemTypography get typography => _theme.typography;

  DesignSystemThemeData get _theme => DesignSystemTheme.of(this);
}
