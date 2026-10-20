enum SkyState {
  clear,
  smoky,
  polluted;

  bool get isSkyDark => this == polluted;

  bool get areCloudsDark => this != clear;
}
