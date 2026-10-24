import 'dart:async';

import 'package:domain/sound/model/game_sound.dart';
import 'package:domain/sound/repository/sound_repository.dart';
import 'package:web/web.dart' as web;

final class SoundRepositoryImpl implements SoundRepository {
  static const _soundsPath = 'assets/resources/assets/sounds';

  final _loops = <GameSound, web.HTMLAudioElement>{};
  final _isMutedController = StreamController<bool>.broadcast();
  var _isMuted = false;

  @override
  bool get isMuted => _isMuted;

  @override
  Stream<bool> get isMutedStream => _isMutedController.stream;

  @override
  void play(GameSound sound) {
    if (_isMuted) {
      return;
    }
    _audio(sound).play();
  }

  @override
  void loop(GameSound sound) {
    stop(sound);
    _loops[sound] = _audio(sound)
      ..loop = true
      ..muted = _isMuted
      ..play();
  }

  @override
  void stop(GameSound sound) {
    final audio = _loops.remove(sound);
    if (audio == null) {
      return;
    }
    audio
      ..pause()
      ..currentTime = 0;
  }

  @override
  void setMuted(bool isMuted) {
    _isMuted = isMuted;
    for (final audio in _loops.values) {
      audio.muted = isMuted;
    }
    _isMutedController.add(isMuted);
  }

  static web.HTMLAudioElement _audio(GameSound sound) => web.HTMLAudioElement()
    ..src = '$_soundsPath/${_fileName(sound)}'
    ..volume = _volume(sound);

  static String _fileName(GameSound sound) => switch (sound) {
    .backgroundMusic => 'background_music.mp3',
    .eating => 'eating_sound.mp3',
    .lose => 'lose_sound.mp3',
    .message => 'message_sound.mp3',
    .pickUp => 'pick_up_sound.mp3',
    .speak => 'speak_sound.mp3',
    .win => 'win_sound.mp3',
  };

  static double _volume(GameSound sound) => switch (sound) {
    .backgroundMusic => 0.07,
    .eating => 0.89,
    .lose => 0.4,
    .message => 0.68,
    .pickUp => 0.68,
    .speak => 0.32,
    .win => 0.47,
  };
}
