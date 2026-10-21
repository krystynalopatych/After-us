import 'package:domain/day/repository/clock_repository.dart';

final class PauseTimeUseCase {
  final ClockRepository _clockRepository;

  const PauseTimeUseCase({required this._clockRepository});

  void call(bool isPaused) => _clockRepository.setPaused(isPaused);
}
