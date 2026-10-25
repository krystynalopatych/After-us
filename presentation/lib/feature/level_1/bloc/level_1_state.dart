part of 'level_1_bloc.dart';

final class Level1State extends Equatable {
  final int run;

  const Level1State({this.run = 0});

  bool get isStarted => run > 0;

  Level1State copyWith({int? run}) => Level1State(run: run ?? this.run);

  @override
  List<Object?> get props => [run];
}
