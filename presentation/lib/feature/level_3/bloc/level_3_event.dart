part of 'level_3_bloc.dart';

sealed class Level3Event {
  const Level3Event();
}

final class Level3Started extends Level3Event {
  const Level3Started();
}
