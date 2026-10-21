import 'package:domain/inventory/model/water_bottle.dart';
import 'package:domain/inventory/model/water_kind.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/water/bloc/water_choice_bloc.dart';

class WaterChoicePage extends StatefulWidget {
  final VoidCallback onClose;

  const WaterChoicePage._({required this.onClose});

  static Widget withBloc({
    required WaterKind water,
    required VoidCallback onClose,
  }) => BlocProvider(
    create: (_) => WaterChoiceBloc()..add(WaterChoiceStarted(water)),
    child: WaterChoicePage._(onClose: onClose),
  );

  @override
  State<WaterChoicePage> createState() => _WaterChoicePageState();
}

class _WaterChoicePageState extends State<WaterChoicePage> {
  static const _shadeOpacity = 0.5;
  static const _messageRect = Rect.fromLTWH(
    410,
    560,
    1100,
    660,
  );
  static const _actionSize = Size(
    320,
    192,
  );

  late final WaterChoiceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WaterChoiceBloc, WaterChoiceState>(
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
            rect: _messageRect,
            child: MessageContainer(
              lines: const ['WHERE SHOULD WATER BE STORED?'],
              actionSize: _actionSize,
              actions: [
                for (final bottle in WaterBottle.values)
                  AnswerButtonContainer(
                    text: _title(bottle),
                    isEnabled: state.bottles.contains(bottle),
                    onTap: () => _bloc.add(WaterChoiceBottleTapped(bottle)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _title(WaterBottle bottle) => switch (bottle) {
    .sodis => 'SODIS BOTTLE',
    .plastic => 'PLASTIC BOTTLE',
  };
}
