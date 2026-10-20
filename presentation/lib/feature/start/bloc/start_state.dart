part of 'start_bloc.dart';

final class StartState extends Equatable {
  final bool isLevelSelection;
  final GameLevel unlockedLevel;

  const StartState({
    this.isLevelSelection = false,
    required this.unlockedLevel,
  });

  StartState copyWith({
    bool? isLevelSelection,
    GameLevel? unlockedLevel,
  }) => StartState(
    isLevelSelection: isLevelSelection ?? this.isLevelSelection,
    unlockedLevel: unlockedLevel ?? this.unlockedLevel,
  );

  @override
  List<Object?> get props => [isLevelSelection, unlockedLevel];
}
