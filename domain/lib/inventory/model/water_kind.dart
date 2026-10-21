enum WaterKind {
  lake,
  strained,
  filtered,
  disinfected,
  boiled;

  bool get isClean => this == filtered || this == disinfected || this == boiled;
}
