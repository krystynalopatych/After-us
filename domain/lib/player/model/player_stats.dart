final class PlayerStats {
  final int health;
  final int hunger;
  final int thirst;

  const PlayerStats({
    required this.health,
    required this.hunger,
    required this.thirst,
  });

  const PlayerStats.initial() : health = 100, hunger = 80, thirst = 80;
}
