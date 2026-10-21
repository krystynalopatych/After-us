import 'package:equatable/equatable.dart';

final class GameDay extends Equatable {
  static const secondsPerDay = 600;
  static const nightLength = 10;

  final int number;
  final int seconds;
  final int nightSeconds;

  const GameDay({
    required this.number,
    required this.seconds,
    this.nightSeconds = 0,
  });

  const GameDay.first() : number = 1, seconds = 0, nightSeconds = 0;

  bool get isOver => seconds >= secondsPerDay;

  bool get isNight => nightSeconds > 0;

  GameDay copyWith({
    int? number,
    int? seconds,
    int? nightSeconds,
  }) => GameDay(
    number: number ?? this.number,
    seconds: seconds ?? this.seconds,
    nightSeconds: nightSeconds ?? this.nightSeconds,
  );

  @override
  List<Object?> get props => [number, seconds, nightSeconds];
}
