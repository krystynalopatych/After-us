import 'package:equatable/equatable.dart';

final class PlayerStats extends Equatable {
  final int health;
  final int hunger;
  final int thirst;

  const PlayerStats({
    required this.health,
    required this.hunger,
    required this.thirst,
  });

  const PlayerStats.initial() : health = 100, hunger = 80, thirst = 80;

  PlayerStats copyWith({
    int? health,
    int? hunger,
    int? thirst,
  }) => PlayerStats(
    health: health ?? this.health,
    hunger: hunger ?? this.hunger,
    thirst: thirst ?? this.thirst,
  );

  @override
  List<Object?> get props => [health, hunger, thirst];
}
