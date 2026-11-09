import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/item_image_extension.dart';
import 'package:presentation/feature/fridge/bloc/fridge_bloc.dart';

class FridgePage extends StatefulWidget {
  final VoidCallback onClose;

  const FridgePage._({required this.onClose});

  static Widget withBloc({required VoidCallback onClose}) => BlocProvider(
    create: (_) => FridgeBloc()..add(const FridgeStarted()),
    child: FridgePage._(onClose: onClose),
  );

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  static const _shadeOpacity = 0.5;
  static const _windowRect = Rect.fromLTWH(
    610,
    430,
    700,
    700,
  );
  static const _imageSize = 1254.0;
  static const _slotRects = [
    Rect.fromLTWH(
      290,
      240,
      300,
      300,
    ),
    Rect.fromLTWH(
      665,
      240,
      300,
      300,
    ),
    Rect.fromLTWH(
      290,
      690,
      300,
      300,
    ),
    Rect.fromLTWH(
      665,
      690,
      300,
      300,
    ),
  ];
  static const _itemPadding = 14.0;
  static const _labelOffset = Offset(
    1340,
    560,
  );

  late final FridgeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgeBloc, FridgeState>(
      bloc: _bloc,
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: .opaque,
              onTap: widget.onClose,
              child: ColoredBox(color: context.colors.base.black.withValues(alpha: _shadeOpacity)),
            ),
          ),
          Positioned.fromRect(
            rect: _windowRect,
            child: context.images.imgFreezerGorshokSlots.image(fit: .contain),
          ),
          for (final (index, stack) in state.slots.indexed)
            Positioned.fromRect(
              rect: _slotScreenRect(_slotRects[index]),
              child: GestureDetector(
                behavior: .opaque,
                onTap: () => _bloc.add(FridgeSlotTapped(index)),
                child: switch (stack) {
                  final stack? => Padding(
                    padding: const EdgeInsets.all(_itemPadding),
                    child: InventorySlotContainer(
                      image: stack.item.asset(context),
                      count: stack.count,
                      isSpoiled: stack.isSpoiled,
                    ),
                  ),
                  null => const SizedBox.expand(),
                },
              ),
            ),
          Positioned(
            left: _labelOffset.dx,
            top: _labelOffset.dy,
            child: LabelContainer(
              text: state.isCooling ? 'WATERED TODAY\nFOOD STAYS FRESH' : 'NEEDS LAKE WATER\nTODAY',
            ),
          ),
        ],
      ),
    );
  }

  static double get _scale => _windowRect.width / _imageSize;

  static Rect _slotScreenRect(Rect slot) => Rect.fromLTWH(
    _windowRect.left + slot.left * _scale,
    _windowRect.top + slot.top * _scale,
    slot.width * _scale,
    slot.height * _scale,
  );
}
