part of 'character_bloc.dart';

sealed class CharacterEvent {
  const CharacterEvent();
}

final class CharacterStarted extends CharacterEvent {
  const CharacterStarted();
}

final class CharacterTapped extends CharacterEvent {
  const CharacterTapped();
}
