import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  start('/'),
  level1('/level-1'),
  level2('/level-2'),
  level3('/level-3');

  final String path;

  const AppRoute(this.path);

  void go(BuildContext context) => Router.neglect(context, () => context.goNamed(name));
}
