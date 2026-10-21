import 'package:domain/station/model/campfire_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/extension/item_image_extension.dart';
import 'package:presentation/extension/material_image_extension.dart';
import 'package:presentation/feature/station/bloc/campfire_bloc.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

class CampfirePage extends StatefulWidget {
  final VoidCallback onClose;

  const CampfirePage._({required this.onClose});

  static Widget withBloc({required VoidCallback onClose}) => BlocProvider(
    create: (_) => CampfireBloc()..add(const CampfireStarted()),
    child: CampfirePage._(onClose: onClose),
  );

  @override
  State<CampfirePage> createState() => _CampfirePageState();
}

class _CampfirePageState extends State<CampfirePage> {
  static const _shadeOpacity = 0.5;
  static const _windowRect = Rect.fromLTWH(
    546,
    415,
    828,
    900,
  );
  static const _imageWidth = 1125.0;
  static const _slotRect = Rect.fromLTWH(
    400,
    604,
    323,
    315,
  );
  static const _itemPadding = 40.0;

  late final CampfireBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CampfireBloc, CampfireState>(
      bloc: _bloc,
      listenWhen: (previous, current) => previous.step != current.step && current.step == .done,
      listener: (context, state) => widget.onClose(),
      builder: (context, state) => Stack(
        fit: .expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: .opaque,
              onTap: () => _onShadeTap(state),
              child: ColoredBox(color: context.colors.base.black.withValues(alpha: _shadeOpacity)),
            ),
          ),
          Positioned.fromRect(
            rect: _windowRect,
            child: context.images.imgFireStack.image(fit: .contain),
          ),
          Positioned.fromRect(
            rect: _slotScreenRect,
            child: GestureDetector(
              behavior: .opaque,
              onTap: () => _bloc.add(const CampfireSlotTapped()),
              child: switch (state.recipe) {
                final recipe? => Padding(
                  padding: const EdgeInsets.all(_itemPadding),
                  child: _image(
                    context,
                    recipe,
                  ).image(fit: .contain),
                ),
                null => const SizedBox.expand(),
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onShadeTap(CampfireState state) {
    if (state.step != .cooking) {
      widget.onClose();
    }
  }

  static double get _scale => _windowRect.width / _imageWidth;

  static Rect get _slotScreenRect => Rect.fromLTWH(
    _windowRect.left + _slotRect.left * _scale,
    _windowRect.top + _slotRect.top * _scale,
    _slotRect.width * _scale,
    _slotRect.height * _scale,
  );

  static AssetGenImage _image(
    BuildContext context,
    CampfireRecipe recipe,
  ) => switch ((recipe.input, recipe.material)) {
    (final input?, _) => input.asset(context),
    (_, final material?) => material.asset(context),
    _ => context.images.imgFireStack,
  };
}
