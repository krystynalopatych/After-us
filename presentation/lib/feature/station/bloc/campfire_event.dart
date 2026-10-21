part of 'campfire_bloc.dart';

sealed class CampfireEvent extends Equatable {
  const CampfireEvent();

  @override
  List<Object?> get props => [];
}

final class CampfireStarted extends CampfireEvent {
  final Station station;

  const CampfireStarted(this.station);

  @override
  List<Object?> get props => [station];
}

final class CampfireSlotTapped extends CampfireEvent {
  const CampfireSlotTapped();
}

final class CampfireMaterialSelected extends CampfireEvent {
  final GameMaterial material;

  const CampfireMaterialSelected(this.material);

  @override
  List<Object?> get props => [material];
}
