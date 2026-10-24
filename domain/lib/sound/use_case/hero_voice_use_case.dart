import 'package:domain/sound/repository/sound_repository.dart';

final class HeroVoiceUseCase {
  final SoundRepository _soundRepository;

  const HeroVoiceUseCase({required this._soundRepository});

  void call(bool isSpeaking) => isSpeaking ? _soundRepository.loop(.speak) : _soundRepository.stop(.speak);
}
