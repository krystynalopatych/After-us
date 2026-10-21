part of 'level_1_bloc.dart';

final class Level1State extends Equatable {
  final bool isStarted;

  const Level1State({this.isStarted = false});

  Level1State copyWith({bool? isStarted}) => Level1State(isStarted: isStarted ?? this.isStarted);

  @override
  List<Object?> get props => [isStarted];
}
