enum GameMaterial {
  plastic(
    airPoints: 3,
    pollutesWater: true,
  ),
  cloth(airPoints: 2),
  sand,
  wood,
  metal(pollutesWater: true),
  organics,
  cardboard,
  seeds,
  clay,
  oil(
    airPoints: 3,
    pollutesWater: true,
    pollutesSoil: true,
  ),
  chlorine(
    pollutesWater: true,
    pollutesSoil: true,
  ),
  electronics(
    airPoints: 5,
    pollutesWater: true,
    pollutesSoil: true,
  ),
  charcoal;

  final int airPoints;
  final bool pollutesWater;
  final bool pollutesSoil;

  const GameMaterial({
    this.airPoints = 1,
    this.pollutesWater = false,
    this.pollutesSoil = false,
  });
}
