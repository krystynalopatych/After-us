import 'package:domain/sound/repository/sound_repository.dart';

final class MuteSoundUseCase {
  final SoundRepository _soundRepository;

  const MuteSoundUseCase({required this._soundRepository});

  void call(bool isMuted) => _soundRepository.setMuted(isMuted);
}
