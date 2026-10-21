part of 'level_2_bloc.dart';

final class Level2State extends Equatable {
  final bool isStarted;

  const Level2State({this.isStarted = false});

  Level2State copyWith({bool? isStarted}) => Level2State(isStarted: isStarted ?? this.isStarted);

  @override
  List<Object?> get props => [isStarted];
}
