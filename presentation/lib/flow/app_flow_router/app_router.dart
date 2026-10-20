import 'package:go_router/go_router.dart';
import 'package:presentation/feature/level_1/page/level_1_page.dart';
import 'package:presentation/feature/level_2/page/level_2_page.dart';
import 'package:presentation/feature/level_3/page/level_3_page.dart';
import 'package:presentation/feature/load_game/page/load_game_page.dart';
import 'package:presentation/feature/start/page/start_page.dart';
import 'package:presentation/flow/app_flow_router/app_route.dart';

abstract final class AppRouter {
  static GoRouter create() {
    var hasStarted = false;

    return GoRouter(
      initialLocation: AppRoute.start.path,
      redirect: (context, state) {
        if (!hasStarted && state.matchedLocation != AppRoute.start.path) {
          return AppRoute.start.path;
        }
        hasStarted = true;
        return null;
      },
      routes: [
        _route(AppRoute.start, (_, _) => const StartPage()),
        _route(AppRoute.loadGame, (_, _) => const LoadGamePage()),
        _route(AppRoute.level1, (_, _) => const Level1Page()),
        _route(AppRoute.level2, (_, _) => const Level2Page()),
        _route(AppRoute.level3, (_, _) => const Level3Page()),
      ],
    );
  }

  static GoRoute _route(AppRoute route, GoRouterWidgetBuilder builder) =>
      GoRoute(path: route.path, name: route.name, builder: builder);
}
