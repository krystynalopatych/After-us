import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/feature/sky/bloc/sky_bloc.dart';

class CloudsPage extends StatefulWidget {
  const CloudsPage._();

  static Widget withBloc() => BlocProvider(
    create: (_) => SkyBloc()..add(const SkyStarted()),
    child: const CloudsPage._(),
  );

  @override
  State<CloudsPage> createState() => _CloudsPageState();
}

class _CloudsPageState extends State<CloudsPage> {
  late final SkyBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkyBloc, SkyState>(
      bloc: _bloc,
      builder: (context, state) => CloudsContainer(state: state),
    );
  }
}
