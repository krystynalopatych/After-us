import 'package:domain/construction/model/construction.dart';
import 'package:domain/location/model/game_location.dart';

enum GameLevel {
  level1(
    farLocation: .dump,
    days: 3,
    goals: {
      .waterFilter,
      .compostPit,
      .rocketStove,
    },
  ),
  level2(
    farLocation: .store,
    days: 4,
    goals: {},
  ),
  level3(
    farLocation: .garage,
    days: 5,
    goals: {},
  );

  final GameLocation farLocation;
  final int days;
  final Set<Construction> goals;

  const GameLevel({
    required this.farLocation,
    required this.days,
    required this.goals,
  });

  List<GameLocation> get locations => [.house, .forest, .lake, farLocation];
}
