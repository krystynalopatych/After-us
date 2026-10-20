part of 'hud_bloc.dart';

sealed class HudEvent extends Equatable {
  const HudEvent();

  @override
  List<Object?> get props => [];
}

final class HudStarted extends HudEvent {
  const HudStarted();
}

final class HudMaterialTapped extends HudEvent {
  final GameMaterial material;

  const HudMaterialTapped(this.material);

  @override
  List<Object?> get props => [material];
}

final class HudSlotTapped extends HudEvent {
  final int slot;

  const HudSlotTapped(this.slot);

  @override
  List<Object?> get props => [slot];
}

final class HudCharacterTapped extends HudEvent {
  const HudCharacterTapped();
}
