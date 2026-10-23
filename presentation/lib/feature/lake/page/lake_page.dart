import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/lake/bloc/lake_bloc.dart';

class LakePage extends StatefulWidget {
  final VoidCallback onWaterTap;

  const LakePage._({required this.onWaterTap});

  static Widget withBloc({required VoidCallback onWaterTap}) => BlocProvider(
    create: (_) => LakeBloc()..add(const LakeStarted()),
    child: LakePage._(onWaterTap: onWaterTap),
  );

  @override
  State<LakePage> createState() => _LakePageState();
}

class _LakePageState extends State<LakePage> {
  static const _changeDuration = Duration(seconds: 3);
  static const _clearWaterRect = Rect.fromLTWH(
    460,
    420,
    980,
    380,
  );
  static const _murkyWaterRect = Rect.fromLTWH(
    380,
    300,
    1200,
    480,
  );

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
          elements: [
            _waterElement(state.isPolluted ? _murkyWaterRect : _clearWaterRect),
          ],
        ),
      ),
    );
  }

  BackgroundElement _waterElement(Rect rect) => BackgroundElement(
    left: rect.left,
    top: rect.top,
    width: rect.width,
    height: rect.height,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: .opaque,
        onTap: widget.onWaterTap,
      ),
    ),
  );
}
