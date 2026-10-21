import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/feature/game/page/game_page.dart';
import 'package:presentation/feature/level_3/bloc/level_3_bloc.dart';

class Level3Page extends StatefulWidget {
  const Level3Page._();

  static Widget withBloc() => BlocProvider(
    create: (_) => Level3Bloc()..add(const Level3Started()),
    child: const Level3Page._(),
  );

  @override
  State<Level3Page> createState() => _Level3PageState();
}

class _Level3PageState extends State<Level3Page> {
  late final Level3Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Level3Bloc, Level3State>(
      bloc: _bloc,
      builder: (context, state) =>
          state.isStarted ? GamePage.withBloc(level: GameLevel.level3) : const SizedBox.shrink(),
    );
  }
}
