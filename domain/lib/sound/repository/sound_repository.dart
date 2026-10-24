import 'package:domain/sound/model/game_sound.dart';

abstract interface class SoundRepository {
  bool get isMuted;

  Stream<bool> get isMutedStream;

  void play(GameSound sound);

  void loop(GameSound sound);

  void stop(GameSound sound);

  void setMuted(bool isMuted);
}
