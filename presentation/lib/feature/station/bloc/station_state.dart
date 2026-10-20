part of 'station_bloc.dart';

final class StationState extends Equatable {
  final Set<Station> built;

  const StationState({this.built = const {}});

  StationState copyWith({Set<Station>? built}) => StationState(built: built ?? this.built);

  @override
  List<Object?> get props => [built];
}
