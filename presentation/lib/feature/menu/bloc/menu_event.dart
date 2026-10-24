part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
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

final class MenuSoundTapped extends MenuEvent {
  const MenuSoundTapped();
}

final class MenuExitTapped extends MenuEvent {
  const MenuExitTapped();
}

final class MenuSaveTapped extends MenuEvent {
  final GameLevel level;

  const MenuSaveTapped(this.level);

  @override
  List<Object?> get props => [level];
}
