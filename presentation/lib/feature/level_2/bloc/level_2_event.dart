part of 'level_2_bloc.dart';

sealed class Level2Event {
  const Level2Event();
}

final class Level2Started extends Level2Event {
  const Level2Started();
}
