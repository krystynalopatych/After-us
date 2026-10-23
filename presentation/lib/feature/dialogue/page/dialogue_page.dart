import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/dialogue/bloc/dialogue_bloc.dart';

class DialoguePage extends StatefulWidget {
  const DialoguePage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => DialogueBloc()..add(const DialogueStarted()),
    child: const DialoguePage._(),
  );

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  static const _heroLineRect = Rect.fromLTWH(
    360,
    1290,
    840,
    280,
  );
  static const _fadeDuration = Duration(milliseconds: 250);

  late final DialogueBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogueBloc, DialogueState>(
      bloc: _bloc,
      builder: (context, state) => IgnorePointer(
        ignoring: state.line == null,
        child: Stack(
          fit: .expand,
          children: [
            Positioned.fill(
              child: GestureDetector(behavior: .opaque),
            ),
            Positioned.fromRect(
              rect: _heroLineRect,
              child: AnimatedSwitcher(
                duration: _fadeDuration,
                child: switch (state.line) {
                  final line? => HeroLineContainer(
                    key: ValueKey(line),
                    text: line,
                    onTyped: () => _bloc.add(const DialogueLineTyped()),
                  ),
                  null => const SizedBox.shrink(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
