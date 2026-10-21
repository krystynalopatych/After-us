import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/lake/bloc/lake_bloc.dart';

class LakePage extends StatefulWidget {
  const LakePage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => LakeBloc()..add(const LakeStarted()),
    child: const LakePage._(),
  );

  @override
  State<LakePage> createState() => _LakePageState();
}

class _LakePageState extends State<LakePage> {
  static const _changeDuration = Duration(seconds: 3);

  late final LakeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final images = context.images;

    return BlocBuilder<LakeBloc, LakeState>(
      bloc: _bloc,
      builder: (context, state) => AnimatedSwitcher(
        duration: _changeDuration,
        child: BackgroundContainer(
          key: ValueKey(state.isPolluted),
          image: state.isPolluted ? images.imgLakeBlackRectangle : images.imgLakeRectangle,
        ),
      ),
    );
  }
}
