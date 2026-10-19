import 'package:domain/character/repository/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/level_3/bloc/level_3_bloc.dart';

class Level3Page extends StatelessWidget {
  const Level3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => Level3Bloc(context.read<CharacterRepository>())..add(const Level3Started()),
      child: BackgroundContainer(image: context.images.level3Background),
    );
  }
}
