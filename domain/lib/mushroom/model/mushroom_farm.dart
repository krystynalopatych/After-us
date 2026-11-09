import 'package:domain/day/model/game_day.dart';
import 'package:equatable/equatable.dart';

final class MushroomFarm extends Equatable {
  static const cardboardNeeded = 2;
  static const growSeconds = GameDay.secondsPerDay;

  final bool isPlaced;
  final bool isPlanted;
  final int seconds;

  const MushroomFarm({
    required this.isPlaced,
    required this.isPlanted,
    required this.seconds,
  });

  const MushroomFarm.none() : isPlaced = false, isPlanted = false, seconds = 0;

  bool get isReady => isPlanted && seconds >= growSeconds;

  double get progress => seconds / growSeconds;

  MushroomFarm copyWith({
    bool? isPlaced,
    bool? isPlanted,
    int? seconds,
  }) => MushroomFarm(
    isPlaced: isPlaced ?? this.isPlaced,
    isPlanted: isPlanted ?? this.isPlanted,
    seconds: seconds ?? this.seconds,
  );

  @override
  List<Object?> get props => [
    isPlaced,
    isPlanted,
    seconds,
  ];
}
