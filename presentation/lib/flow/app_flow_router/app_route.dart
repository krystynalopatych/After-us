import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  start('/'),
  levels('/levels'),
  loadGame('/load-game'),
  level1('/level-1'),
  level2('/level-2'),
  level3('/level-3');

  final String path;

  const AppRoute(this.path);

  static AppRoute fromLevel(GameLevel level) => switch (level) {
    .level1 => level1,
    .level2 => level2,
    .level3 => level3,
  };

  void go(BuildContext context) => Router.neglect(
    context,
    () => context.goNamed(name),
  );
}
