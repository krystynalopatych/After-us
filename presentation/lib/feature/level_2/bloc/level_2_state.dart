part of 'level_2_bloc.dart';

final class Level2State extends Equatable {
  final int run;

  const Level2State({this.run = 0});

  bool get isStarted => run > 0;

  Level2State copyWith({int? run}) => Level2State(run: run ?? this.run);

  @override
  List<Object?> get props => [run];
}
