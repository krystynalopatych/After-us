import 'package:domain/progress/model/game_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/feature/game/page/game_page.dart';
import 'package:presentation/feature/level_2/bloc/level_2_bloc.dart';

class Level2Page extends StatefulWidget {
  const Level2Page._();

  static Widget withBloc() => BlocProvider(
    create: (_) => Level2Bloc()..add(const Level2Started()),
    child: const Level2Page._(),
  );

  @override
  State<Level2Page> createState() => _Level2PageState();
}

class _Level2PageState extends State<Level2Page> {
  late final Level2Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Level2Bloc, Level2State>(
      bloc: _bloc,
      builder: (context, state) => GamePage.withBloc(level: GameLevel.level2),
    );
  }
}
