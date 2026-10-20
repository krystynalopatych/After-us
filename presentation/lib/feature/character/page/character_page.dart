import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/character/bloc/character_bloc.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => CharacterBloc()..add(const CharacterStarted()),
    child: const CharacterPage._(),
  );

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late final CharacterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterBloc, CharacterState>(
      bloc: _bloc,
      builder: (context, state) => CharacterContainer(state: state),
    );
  }
}
