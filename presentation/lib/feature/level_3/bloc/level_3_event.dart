part of 'level_3_bloc.dart';

sealed class Level3Event extends Equatable {
  const Level3Event();

  @override
  List<Object?> get props => [];
}

final class Level3Started extends Level3Event {
  const Level3Started();
}

final class Level3Retried extends Level3Event {
  const Level3Retried();
}
