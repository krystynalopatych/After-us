part of 'level_2_bloc.dart';

sealed class Level2Event extends Equatable {
  const Level2Event();

  @override
  List<Object?> get props => [];
}

final class Level2Started extends Level2Event {
  const Level2Started();
}
