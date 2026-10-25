part of 'level_3_bloc.dart';

final class Level3State extends Equatable {
  final int run;

  const Level3State({this.run = 0});

  bool get isStarted => run > 0;

  Level3State copyWith({int? run}) => Level3State(run: run ?? this.run);

  @override
  List<Object?> get props => [run];
}
