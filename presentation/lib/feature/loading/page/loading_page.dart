import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/design/design_src.dart';
import 'package:presentation/extension/build_context_extension.dart';
import 'package:presentation/feature/loading/bloc/loading_bloc.dart';

class LoadingPage extends StatefulWidget {
  final Widget child;

  const LoadingPage._({required this.child});

  static Widget withBloc({required Widget child}) => BlocProvider(
    create: (_) => LoadingBloc(),
    child: LoadingPage._(child: child),
  );

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final LoadingBloc _bloc;
  var _isPrecacheStarted = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isPrecacheStarted) {
      return;
    }
    _isPrecacheStarted = true;
    final images = context.images.values;
    _bloc.add(LoadingStarted(images.length));
    for (final image in images) {
      precacheImage(
        image.provider(),
        context,
        onError: (_, _) {},
      ).whenComplete(() => _bloc.add(const LoadingImageLoaded()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingBloc, LoadingState>(
      bloc: _bloc,
      builder: (context, state) => state.isDone ? widget.child : LoadingContainer(progress: state.progress),
    );
  }
}
