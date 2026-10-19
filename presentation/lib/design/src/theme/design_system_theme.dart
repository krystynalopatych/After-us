import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme_data.dart';

final class DesignSystemTheme extends InheritedWidget {
  final DesignSystemThemeData data;
  final Brightness brightness;

  const DesignSystemTheme({
    super.key,
    required this.data,
    required this.brightness,
    required super.child,
  });

  static DesignSystemThemeData of(BuildContext context) => _of(context).data;

  static bool isDarkTheme(BuildContext context) => _of(context).brightness == .dark;

  static DesignSystemTheme _of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<DesignSystemTheme>();
    assert(theme != null, 'No DesignSystemTheme found in context');
    return theme!;
  }

  @override
  bool updateShouldNotify(DesignSystemTheme oldWidget) =>
      data != oldWidget.data || brightness != oldWidget.brightness;
}
