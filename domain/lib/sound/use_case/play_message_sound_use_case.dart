import 'package:domain/feedback/model/feedback_message.dart';
import 'package:domain/sound/repository/sound_repository.dart';

final class PlayMessageSoundUseCase {
  final SoundRepository _soundRepository;

  const PlayMessageSoundUseCase({required this._soundRepository});

  void call(FeedbackMessage message) {
    if (message.mood != .sad) {
      return;
    }
    _soundRepository.play(.message);
  }
}
