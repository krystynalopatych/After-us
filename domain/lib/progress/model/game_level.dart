import 'package:domain/location/model/game_location.dart';

enum GameLevel {
  level1(
    farLocation: .dump,
    days: 3,
  ),
  level2(
    farLocation: .store,
    days: 4,
  ),
  level3(
    farLocation: .garage,
    days: 5,
  );

  final GameLocation farLocation;
  final int days;

  const GameLevel({
    required this.farLocation,
    required this.days,
  });

  List<GameLocation> get locations => [.house, .forest, .lake, farLocation];
}
