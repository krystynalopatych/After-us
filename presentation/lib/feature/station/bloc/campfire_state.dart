part of 'campfire_bloc.dart';

enum CampfireStep {
  empty,
  fuel,
  cooking,
  done,
}

final class CampfireState extends Equatable {
  final Station station;
  final CampfireStep step;
  final CampfireRecipe? recipe;
  final CampfireFuel? fuel;

  const CampfireState({
    this.station = .campfire,
    this.step = .empty,
    this.recipe,
    this.fuel,
  });

  CampfireState copyWith({
    Station? station,
    CampfireStep? step,
    CampfireRecipe? Function()? recipe,
    CampfireFuel? Function()? fuel,
  }) => CampfireState(
    station: station ?? this.station,
    step: step ?? this.step,
    recipe: recipe != null ? recipe() : this.recipe,
    fuel: fuel != null ? fuel() : this.fuel,
  );

  @override
  List<Object?> get props => [station, step, recipe, fuel];
}
