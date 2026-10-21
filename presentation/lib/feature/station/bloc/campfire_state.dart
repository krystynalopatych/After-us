part of 'campfire_bloc.dart';

enum CampfireStep {
  empty,
  fuel,
  cooking,
  done,
}

final class CampfireState extends Equatable {
  final CampfireStep step;
  final CampfireRecipe? recipe;
  final CampfireFuel? fuel;

  const CampfireState({
    this.step = .empty,
    this.recipe,
    this.fuel,
  });

  CampfireState copyWith({
    CampfireStep? step,
    CampfireRecipe? Function()? recipe,
    CampfireFuel? Function()? fuel,
  }) => CampfireState(
    step: step ?? this.step,
    recipe: recipe != null ? recipe() : this.recipe,
    fuel: fuel != null ? fuel() : this.fuel,
  );

  @override
  List<Object?> get props => [step, recipe, fuel];
}
