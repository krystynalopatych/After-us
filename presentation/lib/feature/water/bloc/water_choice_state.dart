part of 'water_choice_bloc.dart';

final class WaterChoiceState extends Equatable {
  final WaterKind water;
  final Set<WaterBottle> bottles;
  final bool isDone;

  const WaterChoiceState({
    this.water = .lake,
    this.bottles = const {},
    this.isDone = false,
  });

  WaterChoiceState copyWith({
    WaterKind? water,
    Set<WaterBottle>? bottles,
    bool? isDone,
  }) => WaterChoiceState(
    water: water ?? this.water,
    bottles: bottles ?? this.bottles,
    isDone: isDone ?? this.isDone,
  );

  @override
  List<Object?> get props => [water, bottles, isDone];
}
