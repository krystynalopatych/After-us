part of 'hud_bloc.dart';

sealed class HudEvent {
  const HudEvent();
}

final class HudStarted extends HudEvent {
  const HudStarted();
}

final class HudMaterialTapped extends HudEvent {
  final GameMaterial material;

  const HudMaterialTapped(this.material);
}

final class HudSlotTapped extends HudEvent {
  final int slot;

  const HudSlotTapped(this.slot);
}
