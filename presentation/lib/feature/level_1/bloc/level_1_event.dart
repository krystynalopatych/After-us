part of 'level_1_bloc.dart';

sealed class Level1Event extends Equatable {
  const Level1Event();

  @override
  List<Object?> get props => [];
}

final class Level1Started extends Level1Event {
  const Level1Started();
}

final class Level1Retried extends Level1Event {
  const Level1Retried();
}
