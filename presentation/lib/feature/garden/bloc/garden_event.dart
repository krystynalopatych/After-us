part of 'garden_bloc.dart';

sealed class GardenEvent extends Equatable {
  const GardenEvent();

  @override
  List<Object?> get props => [];
}

final class GardenStarted extends GardenEvent {
  const GardenStarted();
}

final class GardenBedTapped extends GardenEvent {
  const GardenBedTapped();
}
