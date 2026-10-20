enum GameLocation {
  forest,
  lake,
  garage(isFar: true),
  house,
  store(isFar: true),
  dump(isFar: true);

  final bool isFar;

  const GameLocation({this.isFar = false});
}
