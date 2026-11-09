import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/design/src/widget/book/model/book_entry.dart';
import 'package:presentation/design/src/widget/pressable_container/pressable_container.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class BookContainer extends StatelessWidget {
  static const _imageWidth = 1536.0;
  static const _entrySpacing = 18.0;
  static const _slant = -0.18;
  static const _pageRects = [
    Rect.fromLTWH(
      240,
      150,
      470,
      660,
    ),
    Rect.fromLTWH(
      830,
      150,
      430,
      660,
    ),
  ];
  static const _closeRect = Rect.fromLTWH(
    30,
    30,
    130,
    120,
  );

  final List<BookEntry> entries;
  final int spread;
  final VoidCallback onClose;
  final VoidCallback onPreviousTap;
  final ValueChanged<int> onNextTap;

  const BookContainer({
    super.key,
    required this.entries,
    required this.spread,
    required this.onClose,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    final images = Assets.resources.assets.images;
    final style = theme.typography.handwriting.copyWith(color: theme.colors.base.brown);
    final textScaler = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / _imageWidth;
        Rect scaled(Rect rect) => Rect.fromLTWH(
          rect.left * scale,
          rect.top * scale,
          rect.width * scale,
          rect.height * scale,
        );
        final pages = _pages(
          style,
          textScaler,
          scale,
        );
        final spreadCount = (pages.length / _pageRects.length).ceil();

        return Stack(
          fit: .expand,
          children: [
            images.imgCraftBook.image(fit: .fill),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: constraints.maxWidth / 2,
              child: GestureDetector(
                behavior: .opaque,
                onTap: onPreviousTap,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: constraints.maxWidth / 2,
              child: GestureDetector(
                behavior: .opaque,
                onTap: () => onNextTap(spreadCount),
              ),
            ),
            for (final (side, rect) in _pageRects.indexed)
              Positioned.fromRect(
                rect: scaled(rect),
                child: IgnorePointer(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: _entrySpacing * scale,
                    children: [
                      for (final index in pages.elementAtOrNull(spread * _pageRects.length + side) ?? const <int>[])
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.skewX(_slant),
                          child: Text(
                            _text(index),
                            style: style,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            Positioned.fromRect(
              rect: scaled(_closeRect),
              child: PressableContainer(
                image: images.imgButtonClose,
                onTap: onClose,
              ),
            ),
          ],
        );
      },
    );
  }

  String _text(int index) => '${index + 1}. ${entries[index].title}\nINTERESTING FACT: ${entries[index].fact}';

  List<List<int>> _pages(
    TextStyle style,
    TextScaler textScaler,
    double scale,
  ) {
    final pages = <List<int>>[];
    var current = <int>[];
    var used = 0.0;
    for (var index = 0; index < entries.length; index++) {
      final rect = _pageRects[pages.length % _pageRects.length];
      final painter = TextPainter(
        text: TextSpan(
          text: _text(index),
          style: style,
        ),
        textDirection: .ltr,
        textScaler: textScaler,
      )..layout(maxWidth: rect.width * scale);
      final height = painter.height + (current.isEmpty ? 0 : _entrySpacing * scale);
      painter.dispose();
      if (current.isNotEmpty && used + height > rect.height * scale) {
        pages.add(current);
        current = [];
        used = 0;
        index--;
        continue;
      }
      current.add(index);
      used += height;
    }
    if (current.isNotEmpty) {
      pages.add(current);
    }
    return pages;
  }
}
