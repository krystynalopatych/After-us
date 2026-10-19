import 'package:equatable/equatable.dart';
import 'package:presentation/design/src/theme/design_system_colors.dart';
import 'package:presentation/design/src/theme/design_system_typography.dart';

final class DesignSystemThemeData extends Equatable {
  final DesignSystemTypography typography;
  final DesignSystemColors colors;

  const DesignSystemThemeData({
    required this.typography,
    required this.colors,
  });

  factory DesignSystemThemeData.light() {
    const colors = DesignSystemColors.light();
    final typography = DesignSystemTypography.main(colors.base.black);

    return DesignSystemThemeData(
      typography: typography,
      colors: colors,
    );
  }

  factory DesignSystemThemeData.dark() {
    const colors = DesignSystemColors.dark();
    final typography = DesignSystemTypography.main(colors.base.white);

    return DesignSystemThemeData(
      typography: typography,
      colors: colors,
    );
  }

  @override
  List<Object> get props => [
    typography,
    colors,
  ];
}
