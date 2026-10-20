import 'package:domain/construction/model/construction.dart';
import 'package:domain/day/model/level_outcome.dart';
import 'package:equatable/equatable.dart';

final class LevelResult extends Equatable {
  final LevelOutcome outcome;
  final List<Construction> missingGoals;

  const LevelResult({
    required this.outcome,
    this.missingGoals = const [],
  });

  LevelResult copyWith({
    LevelOutcome? outcome,
    List<Construction>? missingGoals,
  }) => LevelResult(
    outcome: outcome ?? this.outcome,
    missingGoals: missingGoals ?? this.missingGoals,
  );

  @override
  List<Object?> get props => [
    outcome,
    missingGoals,
  ];
}
