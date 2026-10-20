import 'package:equatable/equatable.dart';

final class PlayerStats extends Equatable {
  static const maxHealth = 100.0;

  final double health;
  final double hunger;
  final double thirst;
  final double healthCeiling;

  const PlayerStats({
    required this.health,
    required this.hunger,
    required this.thirst,
    this.healthCeiling = maxHealth,
  });

  const PlayerStats.initial() : health = maxHealth, hunger = 80, thirst = 80, healthCeiling = maxHealth;

  PlayerStats copyWith({
    double? health,
    double? hunger,
    double? thirst,
    double? healthCeiling,
  }) => PlayerStats(
    health: health ?? this.health,
    hunger: hunger ?? this.hunger,
    thirst: thirst ?? this.thirst,
    healthCeiling: healthCeiling ?? this.healthCeiling,
  );

  @override
  List<Object?> get props => [health, hunger, thirst, healthCeiling];
}
