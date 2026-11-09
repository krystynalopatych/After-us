import 'package:domain/day/model/game_day.dart';
import 'package:equatable/equatable.dart';

final class GardenBed extends Equatable {
  static const seedsNeeded = 2;
  static const growSeconds = GameDay.secondsPerDay;
  static const greenhouseGrowSeconds = GameDay.secondsPerDay ~/ 2;
  static const harvestYield = 2;
  static const fertilizerBonus = 1;

  final bool isPlaced;
  final int seeds;
  final bool hasGreenhouse;
  final bool isFertilized;
  final int seconds;

  const GardenBed({
    required this.isPlaced,
    required this.seeds,
    required this.hasGreenhouse,
    required this.isFertilized,
    required this.seconds,
  });

  const GardenBed.none() : isPlaced = false, seeds = 0, hasGreenhouse = false, isFertilized = false, seconds = 0;

  bool get isPlanted => seeds >= seedsNeeded;

  int get readySeconds => hasGreenhouse ? greenhouseGrowSeconds : growSeconds;

  bool get isReady => isPlanted && seconds >= readySeconds;

  bool get hasSprouts => isPlanted && seconds * 2 >= readySeconds;

  double get progress => seconds / readySeconds;

  int get harvestCount => harvestYield + (isFertilized ? fertilizerBonus : 0);

  bool get isComplete => isPlanted && hasGreenhouse;

  GardenBed copyWith({
    bool? isPlaced,
    int? seeds,
    bool? hasGreenhouse,
    bool? isFertilized,
    int? seconds,
  }) => GardenBed(
    isPlaced: isPlaced ?? this.isPlaced,
    seeds: seeds ?? this.seeds,
    hasGreenhouse: hasGreenhouse ?? this.hasGreenhouse,
    isFertilized: isFertilized ?? this.isFertilized,
    seconds: seconds ?? this.seconds,
  );

  @override
  List<Object?> get props => [
    isPlaced,
    seeds,
    hasGreenhouse,
    isFertilized,
    seconds,
  ];
}
