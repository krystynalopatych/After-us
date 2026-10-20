import 'package:domain/location/model/game_location.dart';

enum GameLevel {
  level1(farLocation: .dump),
  level2(farLocation: .store),
  level3(farLocation: .garage);

  final GameLocation farLocation;

  const GameLevel({required this.farLocation});

  List<GameLocation> get locations => [.house, .forest, .lake, farLocation];
}
