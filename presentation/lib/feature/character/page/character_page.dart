import 'package:domain/character/repository/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/character/bloc/character_bloc.dart';

class CharacterPage extends StatelessWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterBloc(context.read<CharacterRepository>())..add(const CharacterStarted()),
      child: IgnorePointer(
        child: BlocBuilder<CharacterBloc, CharacterState>(
          builder: (context, state) => CharacterContainer(state: state),
        ),
      ),
    );
  }
}
