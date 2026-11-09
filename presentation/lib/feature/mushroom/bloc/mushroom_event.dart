part of 'mushroom_bloc.dart';

sealed class MushroomEvent extends Equatable {
  const MushroomEvent();

  @override
  List<Object?> get props => [];
}

final class MushroomStarted extends MushroomEvent {
  const MushroomStarted();
}

final class MushroomFarmTapped extends MushroomEvent {
  const MushroomFarmTapped();
}
