import 'package:domain/station/model/station.dart';
import 'package:domain/station/model/station_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/station/bloc/station_build_bloc.dart';

class StationBuildPage extends StatefulWidget {
  final VoidCallback onClose;

  const StationBuildPage._({required this.onClose});

  static Widget withBloc({required VoidCallback onClose}) => BlocProvider(
    create: (_) => StationBuildBloc()..add(const StationBuildStarted()),
    child: StationBuildPage._(onClose: onClose),
  );

  @override
  State<StationBuildPage> createState() => _StationBuildPageState();
}

class _StationBuildPageState extends State<StationBuildPage> {
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

  late final StationBuildBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationBuildBloc, StationBuildState>(
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
            rect: _messageRect,
            child: MessageContainer(
              lines: const ['USING THIS MATERIAL', 'YOU CAN BUILD THE FOLLOWING OBJECTS'],
              actionSize: _actionSize,
              actions: [
                for (final choice in state.choices) _action(choice),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(StationChoice choice) => AnswerButtonContainer(
    text: _title(choice.station),
    isEnabled: choice.canBuild,
    isDone: choice.isBuilt,
    hint: choice.isBuilt ? null : 'NOT ENOUGH RESOURCES!',
    onTap: () {
      _bloc.add(StationBuildTapped(choice.station));
      widget.onClose();
    },
  );

  static String _title(Station station) => switch (station) {
    .campfire => 'CAMPFIRE',
    .workbench => 'WORKBENCH',
    .rocketStove => 'ROCKET STOVE',
  };
}
