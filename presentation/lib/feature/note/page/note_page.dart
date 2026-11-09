import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/note/bloc/note_bloc.dart';

class NotePage extends StatefulWidget {
  final double locationTop;

  const NotePage._({required this.locationTop});

  static Widget withBloc({required double locationTop}) => BlocProvider(
    create: (_) => NoteBloc()..add(const NoteStarted()),
    child: NotePage._(locationTop: locationTop),
  );

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  static const _shadeOpacity = 0.6;
  static const _noteRect = Rect.fromLTWH(
    1180,
    220,
    130,
    130,
  );
  static const _storyRect = Rect.fromLTWH(
    460,
    365,
    1000,
    1000,
  );
  static const _closeRect = Rect.fromLTWH(
    430,
    335,
    150,
    150,
  );

  late final NoteBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final images = context.images;

    return BlocBuilder<NoteBloc, NoteState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          if (state.location == .store)
            Positioned.fromRect(
              rect: _noteRect.translate(
                0,
                widget.locationTop,
              ),
              child: PressableContainer(
                image: images.imgZapyska,
                onTap: () => _bloc.add(const NoteTapped()),
              ),
            ),
          if (state.isOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                behavior: .opaque,
                onTap: () => _bloc.add(const NoteClosed()),
                child: ColoredBox(color: context.colors.base.black.withValues(alpha: _shadeOpacity)),
              ),
            ),
            Positioned.fromRect(
              rect: _storyRect,
              child: images.imgZapyskaStory.image(fit: .contain),
            ),
            Positioned.fromRect(
              rect: _closeRect,
              child: PressableContainer(
                image: images.imgButtonClose,
                onTap: () => _bloc.add(const NoteClosed()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
