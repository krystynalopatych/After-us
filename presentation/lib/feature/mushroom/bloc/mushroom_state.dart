part of 'mushroom_bloc.dart';

final class MushroomState extends Equatable {
  final MushroomFarm farm;

  const MushroomState({required this.farm});

  MushroomState copyWith({MushroomFarm? farm}) => MushroomState(farm: farm ?? this.farm);

  @override
  List<Object?> get props => [farm];
}
