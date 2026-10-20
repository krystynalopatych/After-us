final class PlayerStats {
  final int health;
  final int hunger;

  const PlayerStats({
    required this.health,
    required this.hunger,
  });

  const PlayerStats.initial() : health = 100, hunger = 80;
}
