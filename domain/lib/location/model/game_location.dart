enum GameLocation {
  forest,
  lake,
  garage(
    isFar: true,
    hasSky: false,
  ),
  house,
  store(
    isFar: true,
    hasSky: false,
  ),
  dump(
    isFar: true,
    hasSky: false,
  );

  final bool isFar;
  final bool hasSky;

  const GameLocation({
    this.isFar = false,
    this.hasSky = true,
  });
}
