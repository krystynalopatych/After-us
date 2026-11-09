part of 'garden_bloc.dart';

final class GardenState extends Equatable {
  final GardenBed bed;

  const GardenState({required this.bed});

  GardenState copyWith({GardenBed? bed}) => GardenState(bed: bed ?? this.bed);

  @override
  List<Object?> get props => [bed];
}
