import 'package:domain/feedback/model/feedback_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/feedback/bloc/feedback_bloc.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => FeedbackBloc()..add(const FeedbackStarted()),
    child: const FeedbackPage._(),
  );

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  static const _topMessageRect = Rect.fromLTWH(
    580,
    24,
    760,
    456,
  );
  static const _heroLineRect = Rect.fromLTWH(
    80,
    760,
    840,
    280,
  );
  static const _fadeDuration = Duration(milliseconds: 250);

  late final FeedbackBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      bloc: _bloc,
      builder: (context, state) => IgnorePointer(
        child: Stack(
          fit: .expand,
          children: [
            Positioned.fromRect(
              rect: _topMessageRect,
              child: _fade(
                state.message,
                (message) => TopMessageContainer(text: message.text),
              ),
            ),
            Positioned.fromRect(
              rect: _heroLineRect,
              child: _fade(
                state.message,
                (message) => switch (message.heroLine) {
                  final heroLine? => HeroLineContainer(text: heroLine),
                  null => null,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _fade(
    FeedbackMessage? message,
    Widget? Function(FeedbackMessage message) builder,
  ) {
    final child = message == null ? null : builder(message);
    return AnimatedSwitcher(
      duration: _fadeDuration,
      child: KeyedSubtree(
        key: ValueKey(message),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
