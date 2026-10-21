import 'package:after_us_game/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:presentation/feature/app/page/app_page.dart';

const _imageCacheBytes = 300 << 20;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = _imageCacheBytes;
  registerDependencies();
  runApp(
    AppPage(
      createAppBloc: createAppBloc,
    ),
  );
}
