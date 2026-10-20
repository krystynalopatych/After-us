part of 'hud_bloc.dart';

sealed class HudEvent {
  const HudEvent();
}

final class HudStarted extends HudEvent {
  const HudStarted();
}
