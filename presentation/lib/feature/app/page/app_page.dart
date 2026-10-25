import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/app/bloc/app_bloc.dart';
import 'package:presentation/feature/loading/page/loading_page.dart';
import 'package:presentation/flow/app_flow_router/app_router.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class AppPage extends StatefulWidget {
  final AppBloc Function() createAppBloc;

  const AppPage({
    super.key,
    required this.createAppBloc,
  });

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final GoRouter _router = AppRouter.create();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.createAppBloc(),
      child: MaterialApp.router(
        title: 'After Us',
        routerConfig: _router,
        builder: (context, child) {
          final brightness = MediaQuery.platformBrightnessOf(context);
          return DesignSystemTheme(
            data: brightness == .dark ? .dark() : .light(),
            brightness: brightness,
            child: SceneContainer(
              children: [
                LoadingPage.withBloc(
                  images: _menuImages(context),
                  child: child!,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static List<AssetGenImage> _menuImages(BuildContext context) {
    final images = context.images;
    return [
      images.imgLogoPage,
      images.imgButtonNewGame,
      images.imgButtonLoadGame,
      images.imgButtonExit,
      images.imgButtonLevel1,
      images.imgButtonLevel2,
      images.imgButtonLevel3,
      images.imgButtonBack,
    ];
  }
}
