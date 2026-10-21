import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/design/src/widget/book/model/book_entry.dart';
import 'package:presentation/design/src/widget/pressable_container/pressable_container.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class BookContainer extends StatelessWidget {
  static const _imageWidth = 1536.0;
  static const _entriesPerPage = 5;
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
  final VoidCallback onClose;

  const BookContainer({
    super.key,
    required this.entries,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    final images = Assets.resources.assets.images;
    final style = theme.typography.handwriting.copyWith(color: theme.colors.base.brown);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / _imageWidth;
        Rect scaled(Rect rect) => Rect.fromLTWH(
          rect.left * scale,
          rect.top * scale,
          rect.width * scale,
          rect.height * scale,
        );

        return Stack(
          fit: .expand,
          children: [
            images.imgCraftBook.image(fit: .fill),
            for (final (page, rect) in _pageRects.indexed)
              Positioned.fromRect(
                rect: scaled(rect),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: _entrySpacing,
                  children: [
                    for (final (index, entry) in entries.indexed.skip(page * _entriesPerPage).take(_entriesPerPage))
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.skewX(_slant),
                        child: Text(
                          '${index + 1}. ${entry.title}\nINTERESTING FACT: ${entry.fact}',
                          style: style,
                        ),
                      ),
                  ],
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
}
