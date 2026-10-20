enum GameMaterial {
  plastic(airPoints: 3),
  cloth(airPoints: 2),
  sand,
  wood,
  metal,
  organics,
  cardboard,
  seeds,
  clay,
  oil(airPoints: 3),
  chlorine,
  electronics(airPoints: 5),
  charcoal;

  final int airPoints;

  const GameMaterial({this.airPoints = 1});
}
