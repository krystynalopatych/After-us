part of 'start_bloc.dart';

final class StartState {
  final bool isLevelSelection;
  final GameLevel unlockedLevel;

  const StartState({
    this.isLevelSelection = false,
    required this.unlockedLevel,
  });
}
