import 'package:domain/day/model/game_day.dart';
import 'package:equatable/equatable.dart';

final class CompostPit extends Equatable {
  static const capacity = 4;
  static const readySeconds = GameDay.secondsPerDay;
  static const compostYield = 2;

  final int organics;
  final int seconds;

  const CompostPit({
    required this.organics,
    required this.seconds,
  });

  const CompostPit.empty() : organics = 0, seconds = 0;

  bool get isFull => organics >= capacity;

  bool get isReady => isFull && seconds >= readySeconds;

  double get progress => seconds / readySeconds;

  CompostPit copyWith({
    int? organics,
    int? seconds,
  }) => CompostPit(
    organics: organics ?? this.organics,
    seconds: seconds ?? this.seconds,
  );

  @override
  List<Object?> get props => [organics, seconds];
}
