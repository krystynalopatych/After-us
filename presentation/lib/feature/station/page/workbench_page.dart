import 'package:domain/station/model/workbench_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/item_image_extension.dart';
import 'package:presentation/extension/material_image_extension.dart';
import 'package:presentation/feature/station/bloc/workbench_bloc.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class WorkbenchPage extends StatefulWidget {
  final VoidCallback onClose;

  const WorkbenchPage._({required this.onClose});

  static Widget withBloc({required VoidCallback onClose}) => BlocProvider(
    create: (_) => WorkbenchBloc()..add(const WorkbenchStarted()),
    child: WorkbenchPage._(onClose: onClose),
  );

  @override
  State<WorkbenchPage> createState() => _WorkbenchPageState();
}

class _WorkbenchPageState extends State<WorkbenchPage> {
  static const _shadeOpacity = 0.5;
  static const _windowRect = Rect.fromLTWH(
    310,
    480,
    1300,
    727,
  );
  static const _imageWidth = 1677.0;
  static const _slotRects = [
    Rect.fromLTWH(
      265,
      342,
      205,
      152,
    ),
    Rect.fromLTWH(
      572,
      342,
      188,
      152,
    ),
    Rect.fromLTWH(
      866,
      342,
      190,
      152,
    ),
    Rect.fromLTWH(
      1158,
      342,
      205,
      152,
    ),
  ];
  static const _itemPadding = 16.0;
  static const _craftRect = Rect.fromLTWH(
    800,
    1227,
    320,
    192,
  );

  late final WorkbenchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkbenchBloc, WorkbenchState>(
      bloc: _bloc,
      listenWhen: (previous, current) => !previous.isDone && current.isDone,
      listener: (context, state) => widget.onClose(),
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
            child: context.images.imgCraftingProcess.image(fit: .contain),
          ),
          for (final (index, slot) in state.slots.indexed)
            Positioned.fromRect(
              rect: _slotScreenRect(_slotRects[index]),
              child: GestureDetector(
                behavior: .opaque,
                onTap: () => _bloc.add(WorkbenchSlotTapped(index)),
                child: switch (slot) {
                  final slot? => Padding(
                    padding: const EdgeInsets.all(_itemPadding),
                    child: _image(
                      context,
                      slot,
                    ).image(fit: .contain),
                  ),
                  null => const SizedBox.expand(),
                },
              ),
            ),
          Positioned.fromRect(
            rect: _craftRect,
            child: AnswerButtonContainer(
              text: 'CRAFT',
              onTap: () => _bloc.add(const WorkbenchCraftTapped()),
            ),
          ),
        ],
      ),
    );
  }

  static AssetGenImage _image(
    BuildContext context,
    WorkbenchItem slot,
  ) => switch (slot) {
    WorkbenchItem(:final material?) => material.asset(context),
    WorkbenchItem(:final item?) => item.asset(context),
    _ => context.images.imgCraftingProcess,
  };

  static double get _scale => _windowRect.width / _imageWidth;

  static Rect _slotScreenRect(Rect slot) => Rect.fromLTWH(
    _windowRect.left + slot.left * _scale,
    _windowRect.top + slot.top * _scale,
    slot.width * _scale,
    slot.height * _scale,
  );
}
