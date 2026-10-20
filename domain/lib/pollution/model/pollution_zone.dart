enum PollutionZone {
  water(healthPenalty: 10),
  soil(healthPenalty: 40);

  final double healthPenalty;

  const PollutionZone({required this.healthPenalty});
}
