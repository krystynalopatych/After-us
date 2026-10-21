part of 'level_3_bloc.dart';

final class Level3State extends Equatable {
  final bool isStarted;

  const Level3State({this.isStarted = false});

  Level3State copyWith({bool? isStarted}) => Level3State(isStarted: isStarted ?? this.isStarted);

  @override
  List<Object?> get props => [isStarted];
}
