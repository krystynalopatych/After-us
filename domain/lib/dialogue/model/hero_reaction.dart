enum HeroReaction {
  lakePolluted(line: 'What have I done... The water is turning dark, and this is the only lake around.'),
  trashDumped(line: 'More trash rotting in the open... The air already smells worse.'),
  plasticBurned(line: "Cough... That black smoke can't be good. Wood would have been enough."),
  clothBurned(line: 'Cough... Burning cloth was a bad idea.'),
  tooManyFires(line: 'So much smoke today... I should save the fire for what really matters.'),
  dirtyAir(line: "It's harder to breathe... The air gets heavier every day."),
  darkSky(line: 'The sky is getting darker... Is that because of me?'),
  pollutedWaterDrunk(line: "Ugh... It tastes like plastic. I shouldn't have thrown it in.");

  final String line;

  const HeroReaction({required this.line});
}
