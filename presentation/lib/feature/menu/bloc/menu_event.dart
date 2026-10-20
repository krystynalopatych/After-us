part of 'menu_bloc.dart';

sealed class MenuEvent {
  const MenuEvent();
}

final class MenuStarted extends MenuEvent {
  const MenuStarted();
}

final class MenuToggled extends MenuEvent {
  const MenuToggled();
}

final class MenuClosed extends MenuEvent {
  const MenuClosed();
}

final class MenuSaveTapped extends MenuEvent {
  final GameLevel level;

  const MenuSaveTapped(this.level);
}
