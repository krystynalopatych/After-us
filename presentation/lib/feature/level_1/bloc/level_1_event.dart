part of 'level_1_bloc.dart';

sealed class Level1Event {
  const Level1Event();
}

final class Level1Started extends Level1Event {
  const Level1Started();
}
