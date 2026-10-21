part of 'water_choice_bloc.dart';

sealed class WaterChoiceEvent extends Equatable {
  const WaterChoiceEvent();

  @override
  List<Object?> get props => [];
}

final class WaterChoiceStarted extends WaterChoiceEvent {
  final WaterKind water;

  const WaterChoiceStarted(this.water);

  @override
  List<Object?> get props => [water];
}

final class WaterChoiceBottleTapped extends WaterChoiceEvent {
  final WaterBottle bottle;

  const WaterChoiceBottleTapped(this.bottle);

  @override
  List<Object?> get props => [bottle];
}
