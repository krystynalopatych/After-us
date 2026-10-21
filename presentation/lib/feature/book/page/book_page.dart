import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/book_record_text_extension.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/book/bloc/book_bloc.dart';

class BookPage extends StatefulWidget {
  final VoidCallback onClose;

  const BookPage._({required this.onClose});

  static Widget withBloc({required VoidCallback onClose}) => BlocProvider(
    create: (_) => BookBloc()..add(const BookStarted()),
    child: BookPage._(onClose: onClose),
  );

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  static const _shadeOpacity = 0.6;
  static const _bookRect = Rect.fromLTWH(
    60,
    265,
    1800,
    1200,
  );

  late final BookBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: .opaque,
              child: ColoredBox(color: context.colors.base.black.withValues(alpha: _shadeOpacity)),
            ),
          ),
          Positioned.fromRect(
            rect: _bookRect,
            child: BookContainer(
              entries: [
                for (final record in state.records)
                  BookEntry(
                    title: record.recipe,
                    fact: record.fact,
                  ),
              ],
              onClose: widget.onClose,
            ),
          ),
        ],
      ),
    );
  }
}
