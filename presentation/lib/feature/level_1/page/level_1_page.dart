import 'package:domain/repositories/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/level_1/bloc/level_1_bloc.dart';

class Level1Page extends StatelessWidget {
  const Level1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => Level1Bloc(context.read<CharacterRepository>())..add(const Level1Started()),
      child: BackgroundContainer(image: context.images.level1Background),
    );
  }
}
