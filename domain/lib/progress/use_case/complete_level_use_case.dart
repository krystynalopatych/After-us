import 'package:domain/progress/model/game_level.dart';
import 'package:domain/progress/repository/progress_repository.dart';

final class CompleteLevelUseCase {
  final ProgressRepository _progressRepository;

  const CompleteLevelUseCase({required this._progressRepository});

  void call(GameLevel level) => _progressRepository.completeLevel(level);
}
