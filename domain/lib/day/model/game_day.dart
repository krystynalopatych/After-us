import 'package:equatable/equatable.dart';

final class GameDay extends Equatable {
  static const secondsPerDay = 600;

  final int number;
  final int seconds;

  const GameDay({
    required this.number,
    required this.seconds,
  });

  const GameDay.first() : number = 1, seconds = 0;

  bool get isOver => seconds >= secondsPerDay;

  GameDay copyWith({
    int? number,
    int? seconds,
  }) => GameDay(
    number: number ?? this.number,
    seconds: seconds ?? this.seconds,
  );

  @override
  List<Object?> get props => [number, seconds];
}
