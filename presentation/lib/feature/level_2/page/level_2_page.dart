import 'package:domain/character/repository/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/level_2/bloc/level_2_bloc.dart';

class Level2Page extends StatelessWidget {
  const Level2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => Level2Bloc(context.read<CharacterRepository>())..add(const Level2Started()),
      child: BackgroundContainer(image: context.images.level2Background),
    );
  }
}
