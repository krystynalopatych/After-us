import 'package:domain/sound/repository/sound_repository.dart';

final class StopMusicUseCase {
  final SoundRepository _soundRepository;

  const StopMusicUseCase({required this._soundRepository});

  void call() => _soundRepository.stop(.backgroundMusic);
}
