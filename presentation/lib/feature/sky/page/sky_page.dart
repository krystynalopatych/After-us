import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/sky/bloc/sky_bloc.dart';

class SkyPage extends StatefulWidget {
  final bool hasSun;

  const SkyPage._({required this.hasSun});

  static Widget withBloc({required bool hasSun}) => BlocProvider(
    create: (_) => SkyBloc()..add(const SkyStarted()),
    child: SkyPage._(hasSun: hasSun),
  );

  @override
  State<SkyPage> createState() => _SkyPageState();
}

class _SkyPageState extends State<SkyPage> {
  static const _sunLeft = 515.0;
  static const _sunTop = 230.0;
  static const _sunSize = 220.0;

  late final SkyBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkyBloc, SkyState>(
      bloc: _bloc,
      builder: (context, state) => SkyContainer(
        state: state,
        elements: [
          if (widget.hasSun)
            BackgroundElement(
              left: _sunLeft,
              top: _sunTop,
              width: _sunSize,
              height: _sunSize,
              child: context.images.imgSun.image(fit: .contain),
            ),
        ],
      ),
    );
  }
}
