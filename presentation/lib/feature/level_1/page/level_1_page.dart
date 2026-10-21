import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/extension/level_image_extension.dart';
import 'package:presentation/feature/game/page/game_page.dart';
import 'package:presentation/feature/level_1/bloc/level_1_bloc.dart';
import 'package:presentation/feature/loading/page/loading_page.dart';

class Level1Page extends StatefulWidget {
  const Level1Page._();

  static Widget withBloc() => BlocProvider(
    create: (_) => Level1Bloc()..add(const Level1Started()),
    child: const Level1Page._(),
  );

  @override
  State<Level1Page> createState() => _Level1PageState();
}

class _Level1PageState extends State<Level1Page> {
  static const _level = GameLevel.level1;

  late final Level1Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Level1Bloc, Level1State>(
      bloc: _bloc,
      builder: (context, state) => state.isStarted
          ? LoadingPage.withBloc(
              images: _level.images(context),
              child: KeyedSubtree(
                key: ValueKey(state.run),
                child: GamePage.withBloc(
                  level: _level,
                  onRetry: () => _bloc.add(const Level1Retried()),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
