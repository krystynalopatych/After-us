part of 'station_build_bloc.dart';

final class StationBuildState extends Equatable {
  final List<StationChoice> choices;

  const StationBuildState({this.choices = const []});

  StationBuildState copyWith({List<StationChoice>? choices}) => StationBuildState(choices: choices ?? this.choices);

  @override
  List<Object?> get props => [choices];
}
